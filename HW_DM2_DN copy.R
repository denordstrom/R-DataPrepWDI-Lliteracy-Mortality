###Data management 2 homework
rm(list=ls())
# set my working directory and loaded in packages 
setwd("/Users/devynnordstrom/desktop/USC SPEC Training/Training Data August 2021")
library(tidyverse)

##exercise #1
#download the data set needed for the homework
dataeducation<-read_csv("/Users/devynnordstrom/Desktop/USC SPEC Training/Training Data August 2021/world_bank_data_education.csv")
dataliteracy<-read_csv("/Users/devynnordstrom/Desktop/USC SPEC Training/Training Data August 2021/world_bank_data_literacy_rates.csv")
## had to slice the data i did not need from the rest of the data
dataeducation <- slice(dataeducation, -c(537,538,539,540,541))

###exercise #1A
##reshape the data with a country-year unit of analysis 
#the education data
CleanDataEducation<-dataeducation %>%  
  pivot_longer(names_to = "year", values_to = "Education", -c(1,2,3,4)) %>% 
  select("Country Name", "Country Code", "Series", "year", "Education") 

CleanDataEducation$year <- as.numeric(gsub("\\[.*", "", CleanDataEducation$year))
# renaming the data 
CleanDataEducation["Series"][CleanDataEducation["Series"]=="Barro-Lee: Average years of secondary schooling, age 15-19, total"] <- "Total"
CleanDataEducation["Series"][CleanDataEducation["Series"]=="Barro-Lee: Average years of secondary schooling, age 15-19, female"]<-"Female"
####we can also do this like 
##CleanDataEducation<-CleanDataEducation %>%
#####rename("total = "BAR.SEC.SCHL.1519")
##now I have to pivot wider
FinalCleanedEducation<-CleanDataEducation %>%
  pivot_wider(names_from = "Series", values_from = "Education")


#now for the literacy data 
#c("1970[YR1970]" : ")
dataliteracy<-slice(dataliteracy, -c(799,800,801,802,803))
CleanDataLiteracy<-dataliteracy %>%
  pivot_longer(names_to ="year", values_to = "mortality", -c(1,2,3,4)) %>% 
  select(-`Series Code`)
# renaming the data 
CleanDataLiteracy["Series Name"][CleanDataLiteracy["Series Name"]=="Mortality rate, under-5 (per 1,000 live births)"]<-"Total"
CleanDataLiteracy["Series Name"][CleanDataLiteracy["Series Name"]=="Mortality rate, under-5, female (per 1,000 live births)"]<- "Female"
CleanDataLiteracy["Series Name"][CleanDataLiteracy["Series Name"]=="Mortality rate, under-5, male (per 1,000 live births)"]<-"male"
##make the year have a numeric value
CleanDataLiteracy$year <- as.numeric(gsub("\\[.*", "", CleanDataLiteracy$year))

#now for pivot wider 
FinalCleanedLiteracy<-CleanDataLiteracy %>% 
  pivot_wider(names_from = "Series Name", values_from = "mortality")


####exercise #3
#merge the data sets
mergeddata<-full_join(FinalCleanedEducation, FinalCleanedLiteracy)



