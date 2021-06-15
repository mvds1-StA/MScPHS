library(dplyr)
library(readr)
library(odbc)
library(tibble)
library(faux)
library(synthpop)

channel <- dbConnect(odbc(), dsn="SMRA", uid=.rs.askForPassword("SMRA Username:"), pwd=.rs.askForPassword("SMRA Password:"))

table1<- tbl_df(dbGetQuery(channel, statement="SELECT
AGE_IN_YEARS, SEX, ETHNICITY, SOCIOECONOMIC STATUS
FROM ANALYSIS.SMR01_PI
ORDER BY NEWID()
WHERE ROWNUM <=2001"))
