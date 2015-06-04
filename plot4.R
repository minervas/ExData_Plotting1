#check if data exists for the date range '2007-02-01' to '2007-02-02'
if(!exists('powerdata')) {
  #check if data exists for all dates
  if(!exists('allpowerdata')) {
    #check if data txt file exists
    if (!file.exists('household_power_consumption.txt')) { 
      #check if data zip file exists
      if(!file.exists('power_consumption.zip')) { 
        #download zip file
        download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', method='curl', destfile='power_consumption.zip')
      }
      #unzip zip file
      unzip('power_consumption.zip')
    }
    #read in txt file into data.frame
    allpowerdata = read.csv('household_power_consumption.txt', header=TRUE, sep=';')
    #convert Date variable to Data data type
    allpowerdata$Date = as.Date(allpowerdata$Date, format='%d/%m/%Y')
  }
  #Select data for range '2007-02-01' to '2007-02-02'
  powerdata = allpowerdata[allpowerdata$Date == as.Date('2007-02-01') | allpowerdata$Date == as.Date('2007-02-02'),]
  #convert variables to numeric type
  powerdata$Global_active_power = as.numeric(as.character(powerdata$Global_active_power))
  powerdata$Global_reactive_power = as.numeric(as.character(powerdata$Global_reactive_power))
  powerdata$Voltage = as.numeric(as.character(powerdata$Voltage))
  powerdata$Global_intensity = as.numeric(as.character(powerdata$Global_intensity))
  powerdata$Sub_metering_1 = as.numeric(as.character(powerdata$Sub_metering_1))
  powerdata$Sub_metering_2 = as.numeric(as.character(powerdata$Sub_metering_2))
  powerdata$Sub_metering_3 = as.numeric(as.character(powerdata$Sub_metering_3))
  #convert to Datetime
  powerdata$Time = strptime(paste(as.character(powerdata$Date), as.character(powerdata$Time)), format('%Y-%m-%d %H:%M:%S'))
}
#open png graphics device
png(filename='plot4.png', width=480, height=480) #, bg='transparent') for a transparent background
#split graph into 2 by 2 grid
par(mfrow=c(2, 2))
#make first plot
plot(powerdata$Time, powerdata$Global_active_power, type='l', ylab='Global Active Power', xlab='')
#make second plot
plot(powerdata$Time, powerdata$Voltage, type='l', ylab='Voltage', xlab='datetime')
#make third plot with submetering1 line
plot(powerdata$Time, powerdata$Sub_metering_1, type='l', ylab='Energy sub metering', xlab='')
#draw submetering2 line
points(powerdata$Time, powerdata$Sub_metering_2, type='l', col='red')
#draw submetering3 line
points(powerdata$Time, powerdata$Sub_metering_3, type='l',  col='blue')
#draw legend
legend('topright', lty=1, col=c('black', 'red', 'blue'), legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'))
#draw fourth plot
plot(powerdata$Time, powerdata$Global_reactive_power, type='l', ylab='Global_reactive_power', xlab='datetime')
#write to png
dev.off()
