# This is the R script for the Plot 3.png
library(data.table)
library(dplyr)

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# download and unzip the data
fileName <- "power_consumption.zip"
if (!file.exists(fileName)) {
  download.file(fileUrl, destfile = fileName)
}

if(!file.exists("household_power_consumption.txt")) {
  unzip(fileName)
}

# load the data and filter out rows with the date we need
# note that ? represents missing value
consumption <- fread("./household_power_consumption.txt", na.strings = "?")
consumption <- consumption %>% filter(Date == "1/2/2007" | Date == "2/2/2007")

# paste the date and time column to be a new DateTime column
# convert into POSIXlt format
# timezone: CET for paris (where the data was collected)
consumption <- consumption %>% mutate(DateTime=paste(Date, Time)) %>% 
  select(DateTime, everything()) %>% 
  select(-Date, -Time)
consumption$DateTime <- strptime(consumption$DateTime, format = "%d/%m/%Y %H:%M:%S", 
                                 tz = "CET")

# make the plot and save it into a png file

png(filename = "Plot 3.png", width = 480, height = 480)

with(consumption, plot(DateTime, Sub_metering_1, xlab = "", ylab = "Energy sub metering",
                       type = "n"))
with(consumption, lines(DateTime, Sub_metering_1, type = "l"))
with(consumption, lines(DateTime, Sub_metering_2, type = "l", col = "red"))
with(consumption, lines(DateTime, Sub_metering_3, type = "l", col = "blue"))
legend("topright", col = c("black", "red", "blue"), 
      legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
      lty = c(1,1,1), text.font = 0.5)

dev.off()