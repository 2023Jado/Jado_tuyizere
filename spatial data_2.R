library(sf)

# 1
# load spatial country boundaries and entsoe dataset
ctr <- st_read("ne_10m_admin_0_countries.shp")
df <- read.csv("day2_data_energy_prod_EU_2020-08-03_2020-08-09.csv")

# explore columns: which country column in ctr ar similar to MapCode in df?
unique(df$MapCode)
View(ctr)
ctr$ISO_A2
ctr$WB_A2

# 2
# cleaning MapCode:
# create new col
df$ctr_code <- df$MapCode

# replacing all DE_* cases with DE
# sub("DE_TenneT_GER", "DE", df$ctr_code) # you could do this for every cas individually
# stringr::str_trunc(df$ctr_code, 2, "right", ellipsis = "")
df$ctr_code[grep("DE_", df$ctr_code)] <- "DE"

# replacing NIE with GB
df$ctr_code <- gsub("NIE", "GB", df$ctr_code)

# aggregate over country code
df_aggr <- aggregate(
  df[,c("ActualGenerationOutput", "ActualConsumption", "InstalledGenCapacity")],
  by = list(df$ctr_code),
  FUN = sum,
  na.rm = T
)
colnames(df_aggr)[1] <- "ctr_code"
# OUR cleaning is missing, need to include it before aggregating!

# 3
# now, as our energy data is ready for being joined, we need to take a look at
# the country boundaries layer, which we want to use for joining
ctr$ctr_code <- ctr$WB_A2

# find country codes that are in energy dataset but not in country boundaries
df_aggr$ctr_code[!(df_aggr$ctr_code %in% ctr$ctr_code)]

# NO is the problem!
# TASK FOR NEXT TIME: Assign "NO" for the missing case in 
# ctr$ctr_code