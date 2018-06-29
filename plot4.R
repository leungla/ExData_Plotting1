#
# create data directory and download original dataset if necessary
#
if (!file.exists("~/R/data")) {
    dir.create("~/R/data")
}
zipfile <- "~/R/data/household_power_consumption.zip"
if (!file.exists(zipfile)) {
    download.file(
        url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
        method="curl", destfile=zipfile
    )
    unzip(zipfile, exdir="~/R/data")
}

#
# Read and load the dataset 
# (only using data from 2007-02-01 and 2007-02-02)
#
filep <- file("~/R/data/household_power_consumption.txt")
data <- read.table(text=grep("^[1-2]/2/2007", readLines(filep), value=TRUE), 
                   col.names=c("Date","Time","Global_active_power",
                               "Global_reactive_power","Voltage","Global_intensity",
                               "Sub_metering_1","Sub_metering_2","Sub_metering_3"),
                   sep=";", na="?")
close(filep)
data$Time <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")

#
# Plot PNG
#
png("plot4.png")
par(mfrow=c(2,2))
# Plot 1
plot(data$Time, data$Global_active_power, type="l", 
     xlab="", ylab="Gobal Active Power")
# Plot 2
plot(data$Time, data$Voltage, type="l", xlab="datetime", ylab="voltage")
# Plot 3
plot(data$Time, data$Sub_metering_1, type="l", col="black", 
     xlab="", ylab="Energy sub metering")
lines(data$Time, data$Sub_metering_2, col="red")
lines(data$Time, data$Sub_metering_3, col="blue")
legend("topright", col=c("black", "red", "blue"), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1, lwd=1, box.lwd=0)
# Plot 4
plot(data$Time, data$Global_reactive_power, type="l", 
     xlab="datetime", ylab="Global_reactive_power")
dev.off()
