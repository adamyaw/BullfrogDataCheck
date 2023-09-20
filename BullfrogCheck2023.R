############# setup ###############
install.packages("sqldf")
install.packages("RSQLite")
install.packages('RSQLite', repos='http://cran.us.r-project.org', type="binary")
library(sqldf)
library(dplyr)
library(tidyr)
library(readxl)
BullfrogsS19 <- read_excel("data/BullfrogS19.xlsx")
View(BullfrogsS19)
HuntStartsS19 <- read_excel("data/HuntStartS19.xlsx")
View(HuntStartsS19)
HuntEndsS19 <- read_excel("data/HuntEndS19.xlsx")
############# Last few weeks ############
#read in data
BullfrogsS19 <- read_excel("data/BullfrogS19.xls")
View(BullfrogsS19)
HuntStartsS19 <- read_excel("data/HuntStartS19.xls")
View(HuntStartsS19)
HuntEndsS19 <- read_excel("data/HuntEndS19.xls")
View(HuntEndsS19)
#split out by date
BullfrogsS19$Date <- gsub('.{9}$', '', BullfrogsS19$created_date)
BullfrogsS19 <- sqldf("SELECT * FROM BullfrogsS19 WHERE Date > '2022-10-12'")
write.csv(BullfrogsS19, "data/BullfrogLast.csv")
HuntStartsS19$Date <- gsub('.{9}$', '', HuntStartsS19$created_date)
HuntStartsS19 <- sqldf("SELECT * FROM HuntStartsS19 WHERE Date > '2022-10-12'")
write.csv(HuntStartsS19, "data/HuntStartLast.csv")
HuntEndsS19$Date <- gsub('.{9}$', '', HuntEndsS19$created_date)
HuntEndsS19 <- sqldf("SELECT * FROM HuntEndsS19 WHERE Date > '2022-10-12'")
write.csv(HuntEndsS19, "data/HuntEndLast.csv")

#make new Hunt Point data frame
HuntPointsS19 <- merge(x = HuntStartsS19, y = HuntEndsS19, by.x = "GlobalIDs", by.y = "Hunt_GUID", all.x = TRUE, all.y = FALSE)
View(HuntPointsS19)

write.csv(HuntPointsM, "data/HuntPoints4.csv")
HuntPointsS19 <- read_excel("data/HuntPointsS19.xls")

## Bullfrog Point SQLs ##
#mislabeled adults
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Adult' AND SVL_mm <71")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Adult Male' AND Captured = 'Yes'")
#mislabeled juveniles
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Juvenile' AND SVL_mm >70")
#mislabeled not Metamorphs
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE Total_Length_mm > 0 AND LifestageBF <> 'Late Metamorph' AND LifestageBF <> 'Early Metamorph'")
#mislabeled EMs
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Early Metamorph' AND (Total_Length_mm IS NULL OR Wet_Weight_gm <> 'null')")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Early Metamorph' AND (SVL_mm>Total_Length_mm)")
#mislabeled LMs
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Late Metamorph' AND (Total_Length_mm IS NULL OR Wet_Weight_gm IS NULL) AND Captured = 'Yes'")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Late Metamorph' AND (SVL_mm+2)>Total_Length_mm AND Captured = 'Yes'")
#incorrect sexing of subadults
sqldf("SELECT ObjectID, created_date, LifestageBF, Gender, SVL_mm, CommentsBF_Metrics FROM BullfrogsS19 WHERE SVL_mm<71 AND (Gender = 'Male' OR Gender = 'Female')")
#weird biometrics
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Adult' AND Wet_Weight_gm < 30")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE SVL_mm>160")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE Wet_Weight_gm>350")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Juvenile' AND Wet_Weight_gm>40")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Juvenile' AND Wet_Weight_gm=40")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Juvenile' AND Wet_Weight_gm=30")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE LifestageBF = 'Juvenile' AND Wet_Weight_gm>SVL_mm")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE SVL_mm<90 AND (Wet_Weight_gm*1.4)>SVL_mm")
sqldf("SELECT ObjectID, created_date, LifestageBF, Gender, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE SVL_mm>89 AND SVL_mm<126 AND ((Wet_Weight_gm>(SVL_mm*1.5)) OR (SVL_mm>(Wet_Weight_gm*2)))")
sqldf("SELECT ObjectID, created_date, LifestageBF, Gender, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE SVL_mm>89 AND SVL_mm<126 AND Gender = 'Male' ORDER BY Wet_Weight_gm DESC")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE SVL_mm>125 AND (SVL_mm*1.2)>Wet_Weight_gm")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE SVL_mm>90 AND Wet_Weight_gm<40")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE Total_Length_mm<SVL_mm")
#not captured frogs with metrics
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM BullfrogsS19 WHERE Captured = 'No' AND SVL_mm>0")
#Missing shooter
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM BullfrogsS19 WHERE CatchMethodBF = 'Shot' AND Shooter IS NULL")
#Unnecessary shooter
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM BullfrogsS19 WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Adam Yawdoszyn'")
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM BullfrogsS19 WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Riley Janquart'")
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM BullfrogsS19 WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Leslie Macias'")
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM BullfrogsS19 WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Jack Fogarty'")
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM BullfrogsS19 WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Hannah Weipert'")
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM BullfrogsS19 WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Darcy Beazley'")

#Null data
sqldf("SELECT ObjectID, Captured, LifestageBF, SVL_mm, CommentsBF_Metrics FROM BullfrogsS19 WHERE Captured = 'Yes' AND RecordStatus = 'Valid' AND SVL_mm IS NULL")
sqldf("SELECT ObjectID, Captured, LifestageBF, SVL_mm, CommentsBF_Metrics FROM BullfrogsS19 WHERE Captured = 'Yes' AND RecordStatus = 'Valid' AND Wet_Weight_gm IS NULL AND LifeStageBF <> 'Early Metamorph'")
sqldf("SELECT ObjectID, Captured, LifestageBF, SVL_mm, CommentsBF_Metrics FROM BullfrogsS19 WHERE Captured = 'Yes' AND RecordStatus = 'Valid' AND LifeStageBF IS NULL")
sqldf("SELECT ObjectID, Captured, LifestageBF, SVL_mm, CommentsBF_Metrics FROM BullfrogsS19 WHERE Captured = 'Yes' AND RecordStatus = 'Valid' AND Gender IS NULL")



#Check that each HS/HE has a pair
sqldf("SELECT RecordStatuss, GlobalIDs, OBJECTIDs, BFSection, created_dates, GlobalIDe FROM HuntPointsS19 WHERE OBJECTIDs <> 'NA' AND GlobalIDe IS NULL")
sqldf("SELECT GlobalIDs, OBJECTIDs, BFSection, created_dates, GlobalIDe FROM HuntPointsS19 WHERE OBJECTIDs IS NULL AND GlobalIDe <> 'NA'")

HuntPointsS19$created_dates <- as.character(HuntPointsS19$created_dates)
#no. 1, Hannah 5/16 Mt. Adams Hwy Ditch USE HUNT START TEMP
sqldf("SELECT GlobalID, OBJECTIDs, BFSection, created_dates, GlobalIDe FROM HuntPointsS19 WHERE created_dates LIKE '2023-05-16%'")
#no. 3, Jamie 10/14 Outlet 7 USE MACK'S HUNT END FROM SAME SITE AND NITE
sqldf("SELECT OBJECTIDs, BFSection, created_dates, GlobalIDe FROM HuntPointsS19 WHERE created_dates LIKE '2022-10-14%'")

#check for Hunt Starts with incorrect null values
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStartsS19 WHERE BFSection IS NULL")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStartsS19 WHERE CallAbundance IS NULL")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStartsS19 WHERE NumberSurveyors IS NULL")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStartsS19 WHERE CloudCoverPercent IS NULL")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStartsS19 WHERE WindScale IS NULL")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStartsS19 WHERE HuntStartTempF = '0'")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStartsS19 WHERE HuntStartTempF <20")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStartsS19 WHERE HuntDayOrNight IS NULL")


#check for Hunt Ends with incorrect null values
sqldf("SELECT OBJECTIDe, HuntEndTempF, TotalGarterSnakes, TotalSalamanders, TotalNewts, TotalWesternToads FROM HuntEndsS19 WHERE HuntEndTempF = '0'")
sqldf("SELECT OBJECTIDe, HuntEndTempF, CallAbundanceDuringHunt FROM HuntEndsS19 WHERE CallAbundanceDuringHunt IS NULL")

#check for mistake Hunt End Call Abundance Changes
sqldf("SELECT OBJECTIDs, BFSection, OBJECTIDe, CallAbundance, CallAbundanceDuringHunt FROM HuntPointsS19 WHERE CallAbundanceDuringHunt <> '0' AND CallAbundanceDuringHunt = CallAbundance")
sqldf("SELECT OBJECTIDs, BFSection, OBJECTIDe, CallAbundance, CallAbundanceDuringHunt FROM HuntPointsS19 WHERE CallAbundanceDuringHunt <> '0' AND CallAbundanceDuringHunt < CallAbundance")


###Finding Hunt start/ends with differing values between multiple observers (oh boy)
#creating a unified variable of location and date
HuntPointsS19 <- HuntPointsS19 %>%
  unite("HuntID", c(BFSection,HuntDayOrNight, created_dates), remove = FALSE)
HuntPointsS19
#removing time from the new variable
HuntPointsS19$HuntID <- gsub('.{9}$', '', HuntPointsS19$HuntID)
HuntPointsS19 <- HuntPointsS19[order(HuntPointsS19$HuntID),]
View(HuntPointsS19)
#omg I think this is going to work, selecting records where the new HuntID is the same but another variable differs
sqldf("SELECT OBJECTIDs, HuntID, created_users, CallAbundance FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct CallAbundance) > 1)")
sqldf("SELECT OBJECTIDs, HuntID, created_users, NumberSurveyors FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct NumberSurveyors) > 1)")
sqldf("SELECT OBJECTIDs, HuntID, created_users, CloudCoverPercent FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct CloudCoverPercent) > 1)")
sqldf("SELECT OBJECTIDs, HuntID, created_users, WindScale FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct WindScale) > 1)")
sqldf("SELECT OBJECTIDs, HuntID, created_users, Precipitation FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct Precipitation) > 1)")
sqldf("SELECT OBJECTIDs, HuntID, created_users, HuntStartTempF FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct HuntStartTempF) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, HuntEndTempF FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct HuntEndTempF) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, TotalGarterSnakes FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct TotalGarterSnakes) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, TotalSalamanders FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct TotalSalamanders) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, TotalNewts FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct TotalNewts) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, TotalWesternToads FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct TotalWesternToads) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, TotalNorthernRedLeggeds FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct TotalNorthernRedLeggeds) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, CallAbundanceDuringHunt FROM HuntPointsS19 WHERE HuntID IN (SELECT HuntID FROM HuntPointsS19 GROUP BY HuntID HAVING COUNT(distinct CallAbundanceDuringHunt) > 1)")

options(max.print=1500)

#making a new time variable to check DayOrNight
HuntPointsS19$Time <- gsub('^.{11}', '', HuntPointsS19$created_dates)
View(HuntPointsS19)
sqldf("SELECT OBJECTIDs, HuntID, HuntDayOrNight, Time FROM HuntPointsS19 WHERE HuntDayOrNight = 'Night' AND (Time > '21:00:00' OR Time < '02:30:00')")
sqldf("SELECT OBJECTIDs, HuntID, HuntDayOrNight, Time FROM HuntPointsS19 WHERE HuntDayOrNight = 'Day' AND (Time < '16:00:00' AND Time > '02:30:00')")
