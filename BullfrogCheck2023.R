############# setup ###############
install.packages("sqldf")
install.packages("RSQLite")
install.packages('RSQLite', repos='http://cran.us.r-project.org', type="binary")
library(sqldf)
library(dplyr)
library(tidyr)
library(readxl)
Bullfrogs22Check <- read_excel("Documents/Bullfrog2022/data/Bullfrog22Check.xlsx")
View(Bullfrogs22Check)
HuntStarts22Check <- read_excel("Documents/Bullfrog2022/data/HuntStart22Check.xlsx")
View(HuntStarts22Check)
HuntEnds22Check <- read_excel("Documents/Bullfrog2022/data/HuntEnd22Check.xlsx")
############# Last few weeks ############
#read in data
Bullfrogs22Check <- read_excel("data/Bullfrog22Check.xls")
View(Bullfrogs22Check)
HuntStarts22Check <- read_excel("data/HuntStart22Check.xls")
View(HuntStarts22Check)
HuntEnds22Check <- read_excel("data/HuntEnd22Check.xls")
View(HuntEnds22Check)
#split out by date
Bullfrogs22Check$Date <- gsub('.{9}$', '', Bullfrogs22Check$created_date)
Bullfrogs22Check <- sqldf("SELECT * FROM Bullfrogs22Check WHERE Date > '2022-10-12'")
write.csv(Bullfrogs22Check, "data/BullfrogLast.csv")
HuntStarts22Check$Date <- gsub('.{9}$', '', HuntStarts22Check$created_date)
HuntStarts22Check <- sqldf("SELECT * FROM HuntStarts22Check WHERE Date > '2022-10-12'")
write.csv(HuntStarts22Check, "data/HuntStartLast.csv")
HuntEnds22Check$Date <- gsub('.{9}$', '', HuntEnds22Check$created_date)
HuntEnds22Check <- sqldf("SELECT * FROM HuntEnds22Check WHERE Date > '2022-10-12'")
write.csv(HuntEnds22Check, "data/HuntEndLast.csv")

#make new Hunt Point data frame
HuntPoints22Check <- merge(x = HuntStarts22Check, y = HuntEnds22Check, by.x = "GlobalIDs", by.y = "Hunt_GUID", all.x = TRUE, all.y = FALSE)
View(HuntPoints22Check)

write.csv(HuntPointsM, "data/HuntPoints4.csv")
HuntPoints22Check <- read_excel("data/HuntPoints22Check.xls")

## Bullfrog Point SQLs ##
#mislabeled adults
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Adult' AND SVL_mm <71")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Adult Male' AND Captured = 'Yes'")
#mislabeled juveniles
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Juvenile' AND SVL_mm >70")
#mislabeled not Metamorphs
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE Total_Length_mm > 0 AND LifestageBF <> 'Late Metamorph' AND LifestageBF <> 'Early Metamorph'")
#mislabeled EMs
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Early Metamorph' AND (Total_Length_mm IS NULL OR Wet_Weight_gm <> 'null')")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Early Metamorph' AND (SVL_mm>Total_Length_mm)")
#mislabeled LMs
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Late Metamorph' AND (Total_Length_mm IS NULL OR Wet_Weight_gm IS NULL) AND Captured = 'Yes'")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Late Metamorph' AND (SVL_mm+2)>Total_Length_mm AND Captured = 'Yes'")
#incorrect sexing of subadults
sqldf("SELECT ObjectID, created_date, LifestageBF, Gender, SVL_mm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE SVL_mm<71 AND (Gender = 'Male' OR Gender = 'Female')")
#weird biometrics
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Adult' AND Wet_Weight_gm < 30")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE SVL_mm>160")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE Wet_Weight_gm>350")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Juvenile' AND Wet_Weight_gm>40")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Juvenile' AND Wet_Weight_gm=40")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Juvenile' AND Wet_Weight_gm=30")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE LifestageBF = 'Juvenile' AND Wet_Weight_gm>SVL_mm")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE SVL_mm<90 AND (Wet_Weight_gm*1.4)>SVL_mm")
sqldf("SELECT ObjectID, created_date, LifestageBF, Gender, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE SVL_mm>89 AND SVL_mm<126 AND ((Wet_Weight_gm>(SVL_mm*1.5)) OR (SVL_mm>(Wet_Weight_gm*2)))")
sqldf("SELECT ObjectID, created_date, LifestageBF, Gender, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE SVL_mm>89 AND SVL_mm<126 AND Gender = 'Male' ORDER BY Wet_Weight_gm DESC")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE SVL_mm>125 AND (SVL_mm*1.2)>Wet_Weight_gm")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE SVL_mm>90 AND Wet_Weight_gm<40")
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE Total_Length_mm<SVL_mm")
#not captured frogs with metrics
sqldf("SELECT ObjectID, LifestageBF, SVL_mm, Total_Length_mm, Wet_Weight_gm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE Captured = 'No' AND SVL_mm>0")
#Missing shooter
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM Bullfrogs22Check WHERE CatchMethodBF = 'Shot' AND Shooter IS NULL")
#Unnecessary shooter
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM Bullfrogs22Check WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Adam Yawdoszyn'")
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM Bullfrogs22Check WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Riley Janquart'")
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM Bullfrogs22Check WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Leslie Macias'")
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM Bullfrogs22Check WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Jack Fogarty'")
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM Bullfrogs22Check WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Hannah Weipert'")
sqldf("SELECT ObjectID, CatchMethodBF, Shooter, CommentsBF_Metrics FROM Bullfrogs22Check WHERE CatchMethodBF <> 'Shot' AND Shooter = 'Darcy Beazley'")

#Null data
sqldf("SELECT ObjectID, Captured, LifestageBF, SVL_mm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE Captured = 'Yes' AND RecordStatus = 'Valid' AND SVL_mm IS NULL")
sqldf("SELECT ObjectID, Captured, LifestageBF, SVL_mm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE Captured = 'Yes' AND RecordStatus = 'Valid' AND Wet_Weight_gm IS NULL AND LifeStageBF <> 'Early Metamorph'")
sqldf("SELECT ObjectID, Captured, LifestageBF, SVL_mm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE Captured = 'Yes' AND RecordStatus = 'Valid' AND LifeStageBF IS NULL")
sqldf("SELECT ObjectID, Captured, LifestageBF, SVL_mm, CommentsBF_Metrics FROM Bullfrogs22Check WHERE Captured = 'Yes' AND RecordStatus = 'Valid' AND Gender IS NULL")



#Check that each HS/HE has a pair
sqldf("SELECT RecordStatuss, GlobalIDs, OBJECTIDs, BFSection, created_dates, GlobalIDe FROM HuntPoints22Check WHERE OBJECTIDs <> 'NA' AND GlobalIDe = 'NA'")
sqldf("SELECT GlobalIDs, OBJECTIDs, BFSection, created_dates, GlobalIDe FROM HuntPoints22Check WHERE OBJECTIDs = 'NA' AND GlobalIDe <> 'NA'")

HuntPoints22Check$created_dates <- as.character(HuntPoints22Check$created_dates)
#no. 1, Hannah 5/16 Mt. Adams Hwy Ditch USE HUNT START TEMP
sqldf("SELECT GlobalID, OBJECTIDs, BFSection, created_dates, GlobalIDe FROM HuntPoints22Check WHERE created_dates LIKE '2023-05-16%'")
#no. 3, Jamie 10/14 Outlet 7 USE MACK'S HUNT END FROM SAME SITE AND NITE
sqldf("SELECT OBJECTIDs, BFSection, created_dates, GlobalIDe FROM HuntPoints22Check WHERE created_dates LIKE '2022-10-14%'")

#check for Hunt Starts with incorrect null values
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStarts22Check WHERE BFSection IS NULL")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStarts22Check WHERE CallAbundance IS NULL")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStarts22Check WHERE NumberSurveyors IS NULL")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStarts22Check WHERE CloudCoverPercent IS NULL")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStarts22Check WHERE WindScale IS NULL")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStarts22Check WHERE HuntStartTempF = '0'")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStarts22Check WHERE HuntStartTempF <20")
sqldf("SELECT OBJECTIDs, BFSection, CloudCoverPercent, WindScale, Precipitation, HuntStartTempF FROM HuntStarts22Check WHERE HuntDayOrNight IS NULL")


#check for Hunt Ends with incorrect null values
sqldf("SELECT OBJECTIDe, HuntEndTempF, TotalGarterSnakes, TotalSalamanders, TotalNewts, TotalWesternToads FROM HuntEnds22Check WHERE HuntEndTempF = '0'")
sqldf("SELECT OBJECTIDe, HuntEndTempF, CallAbundanceDuringHunt FROM HuntEnds22Check WHERE CallAbundanceDuringHunt IS NULL")

#check for mistake Hunt End Call Abundance Changes
sqldf("SELECT OBJECTIDs, BFSection, OBJECTIDe, CallAbundance, CallAbundanceDuringHunt FROM HuntPoints22Check WHERE CallAbundanceDuringHunt <> '0' AND CallAbundanceDuringHunt = CallAbundance")
sqldf("SELECT OBJECTIDs, BFSection, OBJECTIDe, CallAbundance, CallAbundanceDuringHunt FROM HuntPoints22Check WHERE CallAbundanceDuringHunt <> '0' AND CallAbundanceDuringHunt < CallAbundance")


###Finding Hunt start/ends with differing values between multiple observers (oh boy)
#creating a unified variable of location and date
HuntPoints22Check <- HuntPoints22Check %>%
  unite("HuntID", c(BFSection,HuntDayOrNight, date), remove = FALSE)
HuntPoints22Check
#removing time from the new variable
HuntPoints22Check$HuntID <- gsub('.{9}$', '', HuntPoints22Check$HuntID)
HuntPoints22Check <- HuntPoints22Check[order(HuntPoints22Check$HuntID),]
View(HuntPoints22Check)
#omg I think this is going to work, selecting records where the new HuntID is the same but another variable differs
sqldf("SELECT OBJECTIDs, HuntID, created_users, CallAbundance FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct CallAbundance) > 1)")
sqldf("SELECT OBJECTIDs, HuntID, created_users, NumberSurveyors FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct NumberSurveyors) > 1)")
sqldf("SELECT OBJECTIDs, HuntID, created_users, CloudCoverPercent FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct CloudCoverPercent) > 1)")
sqldf("SELECT OBJECTIDs, HuntID, created_users, WindScale FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct WindScale) > 1)")
sqldf("SELECT OBJECTIDs, HuntID, created_users, Precipitation FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct Precipitation) > 1)")
sqldf("SELECT OBJECTIDs, HuntID, created_users, HuntStartTempF FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct HuntStartTempF) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, HuntEndTempF FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct HuntEndTempF) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, TotalGarterSnakes FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct TotalGarterSnakes) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, TotalSalamanders FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct TotalSalamanders) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, TotalNewts FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct TotalNewts) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, TotalWesternToads FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct TotalWesternToads) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, TotalNorthernRedLeggeds FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct TotalNorthernRedLeggeds) > 1)")
sqldf("SELECT OBJECTIDe, HuntID, HuntDayOrNight, created_users, CallAbundanceDuringHunt FROM HuntPoints22Check WHERE HuntID IN (SELECT HuntID FROM HuntPoints22Check GROUP BY HuntID HAVING COUNT(distinct CallAbundanceDuringHunt) > 1)")

options(max.print=1500)

#making a new time variable to check DayOrNight
HuntPoints22Check$Time <- gsub('^.{11}', '', HuntPoints22Check$created_dates)
View(HuntPoints22Check)
sqldf("SELECT OBJECTIDs, HuntID, HuntDayOrNight, Time FROM HuntPoints22Check WHERE Time < '21:00:00' AND Time > '02:00:00'")
