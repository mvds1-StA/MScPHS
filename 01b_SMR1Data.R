### SECTION 01b_SMR1Data
### This section on focuses on extracting the data from the SMR1 database
### and saving this to functions and files.

### Set Seed and defining patients
seed_data <- set.seed( "5482" )

### Loading the data set
channel <- dbConnect(odbc(), dsn="SMRA", uid=.rs.askForPassword("SMRA Username:"), pwd=.rs.askForPassword("SMRA Password:"))

### Using table_test to figure out names of variables for selection
table_test <- tibble::as_tibble(dbGetQuery(channel, statement="SELECT
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

## Checking the divsion across gender and ethnic groups
table(SMR1_data[c("SEX")])
table(SMR1_data[c("ETHNIC_GROUP")])


### Disconnect from the channel to not overload the system
dbDisconnect(channel)

### Saving the file of data and values
save (
  SMR1_data,
  file=sprintf( "files_created/01b_SMR1.Rdat",
                number_patients )
)