# Download the file
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile = "./pow_consumption.zip")
# Extract it
unzip("./pow_consumption.zip")
# Read it
data <- read.table("./household_power_consumption.txt",sep=";", header=TRUE, na.strings = "?")
# Filter data from 01/02/2007 to 02/02/2007
filter <- as.Date(data$Date,"%d/%m/%Y") %in% c(as.Date("01/02/2007","%d/%m/%Y"),as.Date("02/02/2007","%d/%m/%Y"))
data <- data[filter,]
# Convert date/time columns into proper class columns
data$Date <- as.Date(data$Date, format="%d/%m/%Y")
data$Time <- strptime(paste(data$Date, data$Time), format="%Y-%m-%d %H:%M:%S")

# Plot Global Active Power histogram
with(data, hist(Global_active_power, col="red",
                         xlab="Global Active Power (kilowatts)",
                         main="Global Active Power"))
# Save it as plot1.png
dev.copy(png,'plot1.png',  width = 480, height = 480)
dev.off()

# Set local LC_TIME to en_US for proper day name in week labels
locale_original <- Sys.getlocale( category = "LC_TIME" )
Sys.setlocale("LC_TIME", "English")

# Plot time-Global Active Power
with(data, plot(Time, Global_active_power, 
                         type="l",
                         xlab="",
                         ylab="Global Active Power (kilowatts)",
                         cex.lab=0.7, cex.axis=0.8))

# Save it as plot2.png
dev.copy(png,'plot2.png',  width = 480, height = 480)
dev.off()

# Plot Submetering lines
plot(data$Time, data$Sub_metering_1, 
     type="l", ylab="Energy sub metering", cex.lab=0.7)
# Add other submeterings as separate lines
lines(data$Time, data$Sub_metering_2, col="red")
lines(data$Time, data$Sub_metering_3, col="blue")
# Print the legend
legend("topright", legend=names(data)[grepl("metering", names(data))], 
       lty=c(1,1,1), col=c("black","red", "blue"), cex=0.8)
# Save it as plot3.png
dev.copy(png,'plot3.png',  width = 480, height = 480)
dev.off()

# Plot4 : four plots in a 2x2 frame
par(mfrow=c(2,2))
# 1,1 Time - Global_active_power
with(data, plot(Time, Global_active_power, 
                         type="l",
                         xlab="", ylab="Global Active Power", 
                         cex.lab=0.7, cex.axis=0.8,
))

# 1,2 Time - Voltage
with(data, plot(Time, Voltage, 
                         type="l",
                         xlab="", ylab="Voltage", 
                         cex.lab=0.7, cex.axis=0.8,
))

# 2,1 
plot(data$Time, data$Sub_metering_1, 
     type="l", ylab="Energy sub metering", xlab="", cex.lab=0.7, cex.axis=0.8)
lines(data$Time, data$Sub_metering_2, col="red")
lines(data$Time, data$Sub_metering_3, col="blue")
legend("topright", legend=names(data)[grepl("metering", names(data))], 
       lty=c(1,1,1), col=c("black","red", "blue"), cex=0.7, bty="n")

# 2,2 Time - Global_reactive_power
with(data, plot(Time, data$Global_reactive_power, 
                         type="l",lwd=0.5,
                         xlab="datetime", ylab="Global_reactive_power", 
                         cex.lab=0.7, cex.axis=0.8))

# Save it as plot4.png
dev.copy(png,'plot4.png',  width = 480, height = 480)

dev.off()

# Restore local LC_TIME to system value
Sys.setlocale( category = "LC_TIME", locale = locale_original )

