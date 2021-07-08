### SECTION
### This section 

### Load
load("files_created/01d_SMR1wPostal.Rdat")
SMR1_SimulatedDataPostal

### Defining a new function with the existing data set 
#SMR1_SimulatedDataPostal <- as_tibble(SMR1_SimulatedDataPostal)

recruitmentVariable.defintion = 
  recruitment <- defData( varname = "RECRUITED",
                        dist = "categorical",
                        formula = genCatFormula(0.50,0.50))

#Generating the data
recruitmentVariable.synthetic = genData( number_patients,
                                    recruitmentVariable.defintion )
#recruitmentVariable.synthetic

### Updating recruitment to Yes/No
recruitmentVariable.synthetic = recruitmentVariable.synthetic %>% 
  mutate(RECRUITED = recode(RECRUITED,
                           "1"="Yes",
                           "2"="No") )
#recruitmentVariable.synthetic

### Defining and adding the recruitment variable
RECRUITED = recruitmentVariable.synthetic 
SMR1_SimulatedDataRecruited <- cbind(SMR1_SimulatedDataPostal, 
                                     RECRUITED)
SMR1_SimulatedDataRecruited

### Removing the id with S and adding a new ID colu
SMR1_SimulatedDataRecruited <- subset (SMR1_SimulatedDataRecruited, 
                                       select = -id)  
SMR1_SimulatedDataRecruited <- tibble::rowid_to_column(SMR1_SimulatedDataRecruited, 
                                                       "ID")
SMR1_SimulatedDataRecruited

#simulatedTrial %>% 
  #dplyr::select(ID, AGE_IN_YEARS, SEX, ETHNIC_GROUP, RECRUITMENT)

#simulatedTrial

### Saving the file of data and values
save (
  SMR1_SimulatedDataRecruited,
  file=sprintf( "files_created/01D_SimulatedSMR1WRecruitment.Rdat",
                  number_patients )
  )
  
  