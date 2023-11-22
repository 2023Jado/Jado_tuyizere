# Always started with having fun with funny codes:
library(fortunes)
fortune()
fortune("memory")

# Some other codes:
library(cowsay)
say("Hello World
    Here Jado jr, is looking forward to 
    coding for the best of our planet and 
    its atmosphere as well.")

someone_say_hello <- function(){
  animal <- sample(names(animals), 1)
  say(paste("Hello, I am a ", animal, ".", collapse = ""), by = animal)
}
someone_say_hello()

someone_say_fortune <- function() {
  animal <- sample(names(animals), 1)
  say(paste(fortune(), collapse = "\n"), by = animal)
  }

someone_say_fortune()

# Sun and moon position_packages:
library("suncalc")
library("V8")

getSunlightTimes(date = Sys.Date(), lat = 49.782332, lon = 9.970187, tz ="CET")

# Whatsapping in R:
library(rwhatsapp)

history <- system.file("extdata", "sample.txt", package = "rwhatsapp")
history
chat <- rwa_read(history)
chat

# Plotting data:
  # Plot SRTM against NDVI on a scatterplot:
df <- mv <- read.csv("https://raw.githubusercontent.com/wegmann/R_data/master/Steigerwald_sample_points_all_data_subset_withNames.csv", header=T)
names(df)
df1 <- df[, c(14, 34, 45)]
df1

  # Subsetting data:
df2 <- subset(df1, df1$L8.ndvi>=0.5)
plot(df2$SRTM, df2$L8.ndvi)
df3 <- subset(df1, df1$L8.ndvi>0.3 & df1$LCname=="urban")
plot(df3$SRTM, df3$L8.ndvi)

# ggplot2 coding:
library(ggplot2)
library(mapping)

df4 <- ggplot(df3, aes(x=SRTM, y=L8.ndvi)) + geom_point(size=2)
plot(df4)

# Adding column:
df5 <- ggplot(df1, aes(x=SRTM, y=L8.ndvi, colour=LCname)) + geom_point(alpha = 0.5)
plot(df5)

# Adding title and x & y-axis labels:
df6 <- ggplot(df1, aes(x=SRTM, y=L8.ndvi, colour=LCname)) + geom_point(alpha = 0.5) +
  labs(title = " NDVI vs SRTM ", x="SRTM", y="NDVI")
plot(df6)

# Creating histogram:
df7 <- ggplot(df1, aes(SRTM)) + geom_histogram(color="green")
plot(df7)

# creating a density graph:
df8 <- ggplot(df1, aes(SRTM)) + geom_density(color="blue")
plot(df8)

# Combining both hist and density plus another geom:
df9 <- ggplot(df1) + geom_histogram(aes(SRTM, after_stat(density),
                                        fill="red", color="darkgreen")) + 
                                      geom_density(aes(SRTM, after_stat(density)), 
                                                   colour="yellow") + 
                                      geom_rug(aes(SRTM))
plot(df9)

# Create plot with just counts:
df10 <- ggplot(df1, aes(LCname, colour=LCname)) + geom_point(stat = "count", size = 2)
plot(df10)

# Adding bar plot but flipped:
df11 <- ggplot(df1) + geom_bar(aes(LCname)) + coord_flip()
plot(df11)

# Adding barplot grouped in categories:
df12 <- ggplot(df1, aes(LCname, fill=LCname)) + geom_bar(position="dodge") + scale_fill_grey()
plot(df12)

# Generate a simple boxplot:
df13 <- ggplot(df1, aes(LCname, SRTM)) + geom_boxplot()
plot(df13)

# Adding some values in jitter:
df14 <- ggplot(df1, aes(LCname, SRTM)) + geom_boxplot() + geom_jitter()
plot(df14)

# Changing the colour and translucency:
df15 <- ggplot(df1, aes(LCname, SRTM)) + geom_boxplot() + geom_jitter(alpha = 0.5, width = 3, colour = "darkblue")
plot(df15)

# Cutting continuous values for using in a boxplot:
names(df)
df1$L8.SAVI <- df$L8.savi
names(df1)
df16 <- ggplot(df1, aes(SRTM, L8.SAVI)) +
  geom_boxplot(aes(group = cut_width(SRTM, 0.5)), outlier.alpha = 0.1) +
  geom_jitter(width = 0.02, size = 2, alpha = 0.5, colour = "blue")
plot(df16)

# Split by a predefined category:
df17 <- ggplot(df1, aes(L8.ndvi)) +
  geom_bar () +
  facet_grid(LCname ~.)
plot(df17)


# 2D Density plot:
df18 <- ggplot(df1, aes(SRTM, L8.ndvi)) +
  geom_point(size=2) + geom_density2d(colour="orange")
plot(df18)

# Scatter plot with hexbins:
df19 <- ggplot(df1, aes(SRTM, L8.ndvi)) + geom_hex(bins = 45)
plot(df19)

# Adding a regression line:
df20 <- ggplot(df1, aes(SRTM, L8.ndvi)) + geom_point() +
  geom_smooth(method = lm)
plot(df20)

# ggplot2 plots and themes:
df21 <- ggplot() + geom_point(data=df1, aes(SRTM, L8.ndvi, colour = LCname)) + theme_bw()
plot(df21)

# Additional plotting:
df22 <- ggplot(df1, aes(x=SRTM, y=L8.ndvi, colour=LCname)) +
  geom_violin() + theme_bw()
plot(df22)

df23 <- ggplot(df1, aes(x=L8.ndvi, y=SRTM)) +
  geom_point(aes(color=LCname), size=2) +
  facet_grid(.~ LCname)
plot(df23)
