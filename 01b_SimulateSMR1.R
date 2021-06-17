### Loading the appropriate libraries 
library(dplyr)
library(readr)
library(odbc)
library(tibble)

### Set Seed and defining patients
seed_data <- set.seed( "5482" )
number_patients = 20

### Loading the data set
channel <- dbConnect(odbc(), dsn="SMRA", uid=.rs.askForPassword("SMRA Username:"), pwd=.rs.askForPassword("SMRA Password:"))

### Using table_test to figure out names of variables for selection
table_test <- tbl_df(dbGetQuery(channel, statement="SELECT
*
FROM ANALYSIS.SMR01_PI
WHERE rownum=1"))
table_test

### Getting the information extracted and randomising the data
table_SMR1 <- tbl_df (dbGetQuery(channel, statement="SELECT
AGE_IN_YEARS, SEX, ETHNIC_GROUP
FROM ANALYSIS.SMR01_PI
WHERE ETHNIC_GROUP IS NOT NULL AND rownum<=10  
ORDER BY DBMS_RANDOM.VALUE"))
table_SMR1

### Disconnect from the channel to not overload the system
dbDisconnect(channel)

### Using Faux to simulate the data just gathered
#install.packages("faux")
library(faux)
tableSimulated_SMR1 <- sim_df(table_SMR1Simulated, number_patients, between =  c("SEX", "ETHNIC_GROUP"))
tableSimulated_SMR1

### Saving the file of data and values
save (
  table_SMR1,
  tableSimulated_SMR1,
  file=sprintf( "files_created/01b_SimulatedSMR1.Rdat",
                number_patients )
)


