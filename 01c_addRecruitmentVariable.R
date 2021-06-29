### Load
#simulatedTrial <- load("files_created/01b_SimulatedSMR1.Rdat")
simulatedNeutral <- simulatedSMR1_data

### Defining a new function with the existing data set 
#simulatedTrial <- as_tibble(simulatedTrial)

recruitmentVariable.defintion = 
  recruitment <- defData( varname = "RECRUITMENT",
                        dist = "categorical",
                        formula = genCatFormula(0.66,0.34))

#Generating the data
recruitmentVariable.synthetic = genData( number_patients,
                                    recruitmentVariable.defintion )

### Updating recruitment to Yes/No
recruitmentVariable.synthetic = recruitmentVariable.synthetic %>% 
  mutate( RECRUITMENT = recode( RECRUITMENT,
                           "1"="Yes",
                           "2"="No") )

### Defining and adding the recruitment variable
simulatedNeutral$RECRUITMENT <- recruitmentVariable.synthetic

### Removing the id with S and adding a new ID colu
simulatedNeutral <- subset (simulatedNeutral, select = -id)
simulatedNeutral <- tibble::rowid_to_column(simulatedNeutral, "ID")
simulatedNeutral

### Saving the file of data and values
save (
  simulatedNeutral,
  file=sprintf( "files_created/01C_SimulatedSMR1WRecruitment.Rdat",
                  number_patients )
  )
  
  