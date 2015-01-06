get_data <- function(){
    #Check if the data file exist, if not, download it.
    if (!file.exists('household_power_consumption.zip')){
        download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', 'household_power_consumption.zip', method='curl')
    }
    #Check if the zip data file exist and it is already unzip, if not, unzip the file.
    if (!file.exists('household_power_consumption.txt') && (file.exists('household_power_consumption.zip'))) {
        library(R.utils)
        unzip('household_power_consumption.zip', 'household_power_consumption.txt')
    }
    #Now that we are sure we have the data, let's select only the dates we are interested in.
    select <- "SELECT * from file WHERE Date='1/2/2007' OR Date='2/2/2007'"
    #we can use sqldf to read only the part of the data we are interested in.
    library(sqldf)
    data <- read.csv.sql('household_power_consumption.txt', sql=select, sep=';')
    #now, let's convert the dates and time to a confortable format for the dataframe
    data$DateTime <- as.POSIXct(strptime(paste(data$Date, data$Time), '%d/%m/%Y %H:%M:%S'))
    #The data is ready to be used
    return(data)
}

#reading the data using get_data()
data <- get_data()

#preparing the png engine.
png(filename = 'plot4.png', width = 480, height = 480, units = 'px', bg = 'white')
#fixing the margins and plotting.
par(mfrow = c(2,2))

#1st plot
plot(data$DateTime, data$Global_active_power, type='l', xlab='',ylab='Global Active Power')
#2nd plot
plot(data$DateTime, data$Voltage, type='l', xlab='datetime', ylab='Voltage')
#3rd plot
plot(data$DateTime, data$Sub_metering_1, type='l', xlab='',ylab='Energy sub metering')
lines(data$DateTime, data$Sub_metering_2, type='l', col='red')
lines(data$DateTime, data$Sub_metering_3, type='l', col='blue')
legend('topright', names(data)[7:9], bty='n', lty=c(1,1,1), lwd=c(1,1,1), col=c('black', 'red', 'blue'))
#4th plot
plot(data$DateTime, data$Global_reactive_power, type='l', xlab='datetime', ylab='Global_reactive_power')

dev.off()