library(data.table)
library(ggplot2)
path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

CombRelated <- grepl("comb", SCC[, SCC.Level.One], ignore.case=TRUE)
CoalRelated <- grepl("coal", SCC[, SCC.Level.Four], ignore.case=TRUE) 
CombSCC <- SCC[CombRelated & CoalRelated, SCC]
CombNEI <- NEI[NEI[,SCC] %in% CombSCC]

png("plot4.png")

ggplot(CombNEI,aes(x = factor(year),y = Emissions/10^5)) +
  geom_bar(stat="identity", fill ="#FF9999", width=0.75) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US (1999-2008)"))

dev.off()
