### Loading the appropriate libraries 
library(dplyr)
library(readr)
library(odbc)
library(tibble)

### Set Seed and defining patients
seed_data <- set.seed( "5482" )

### Loading the data set
channel <- dbConnect(odbc(), dsn="SMRA", uid=.rs.askForPassword("SMRA Username:"), pwd=.rs.askForPassword("SMRA Password:"))

### Using table_test to figure out names of variables for selection
table_test <- tbl_df(dbGetQuery(channel, statement="SELECT
*
FROM ANALYSIS.SMR01_PI
WHERE rownum=1"))
table_test

### Getting the information extracted and randomising the data
SMR1_query <- sprintf("SELECT
AGE_IN_YEARS, SEX, ETHNIC_GROUP
FROM ANALYSIS.SMR01_PI
WHERE ETHNIC_GROUP IS NOT NULL AND rownum<=%d 
ORDER BY DBMS_RANDOM.VALUE", number_patients)

SMR1_data <- as_tibble(dbGetQuery(channel, statement=SMR1_query))
SMR1_data

### Disconnect from the channel to not overload the system
#dbDisconnect(channel)

### Ensuring that the variables are numeric for the Faux package
SMR1_dataNew <- SMR1_data %>%
  mutate(SEX = as.numeric(SEX)) %>%
  #mutate(SEX = round(SEX, 0)) 
  mutate(ETHNIC_GROUP = as.numeric(ETHNIC_GROUP)) 
  #mutate(ETHNIC_GROUP = round(ETHNIC_GROUP, 0)) 
SMR1_dataNew


### Using Faux to simulate the data just gathered
library(faux)
simulatedSMR1_dataNew <- sim_df(SMR1_dataNew, number_patients)
simulatedSMR1_dataNew

SMR1_SimulatedDataComplete <- simulatedSMR1_dataNew %>%
  mutate(SEX = round(simulatedSMR1_dataNew$SEX, digits=0))  %>%
  mutate(ETHNIC_GROUP = round(simulatedSMR1_dataNew$ETHNIC_GROUP, digits=0))  %>%
  mutate(AGE_IN_YEARS = round(simulatedSMR1_dataNew$AGE_IN_YEARS, digits=0))

SMR1_SimulatedDataComplete

### Saving the file of data and values
save (
  SMR1_data,
  SMR1_SimulatedDataComplete,
  file=sprintf( "files_created/01b_SimulatedSMR1.Rdat",
                number_patients )
)


