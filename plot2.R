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
png(filename = 'plot2.png', width = 480, height = 480, units = 'px', bg = 'white')
#fixing the margins and plotting.
par(mar = c(6,6,5,4))
plot(data$DateTime, data$Global_active_power, type='l', xlab='',ylab='Global active power (kilowatts)')
dev.off()