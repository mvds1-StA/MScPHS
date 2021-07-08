### SECTION 03a_BiasGender
### This section biases the simulated data based on the variable gender.

### Assigning Gender bias to the dataset 
SMR1_SimulatedDataComplete_GENDER = SMR1_SimulatedDataComplete

### Defining when probability of YES/NO for each gender
### and setting this in a function
female_bias <- 0.7
male_bias <- 0.3

SMR1_SimulatedDataBiasGender <- SMR1_SimulatedDataComplete_GENDER %>%
  mutate(SEX_Bias = case_when(SEX == "1" ~ female_bias,
                          SEX == "2" ~ male_bias))

### Defining the functions of neutral recruitment and biased recruitment
recruitment_definition.neutral = defDataAdd( varname = "RECRUITMENT_SEXneutral",
                                             dist    = "binary",
                                             formula = 0.5 )

recruitment_definition.biased = defDataAdd( varname = "RECRUITMENT_SEXbias",
                                            dist    = "binary",
                                            formula = "SEX_Bias")

### Adding the columns of neutral and biased to the table
SMR1_SimulatedDataBiasGender.new1 = addColumns(recruitment_definition.neutral,
                                           as.data.table(SMR1_SimulatedDataBiasGender))

SMR1_SimulatedDataBiasGender.new2 = addColumns(recruitment_definition.biased,
                                           as.data.table(SMR1_SimulatedDataBiasGender.new1))

#SMR1_SimulatedDataBiasGender.new2

### Transforming the binary values to Yes and No
#SMR1_SimulatedDataBiasGender.new2 = SMR1_SimulatedDataBiasGender.new2 %>% 
  #mutate( RECRUITMENT_SEXneutral = recode( RECRUITMENT_SEXneutral,
                                                 #"0"="Yes",
                                                 #"1"="No") ) %>% 
  
  #mutate( RECRUITMENT_SEXbias = recode( RECRUITMENT_SEXbias,
                                              #"0"="Yes",
                                              #"1"="No") )
SMR1_SimulatedDataBiasGender.new2

### Saving the files
save (
  SMR1_SimulatedDataBiasGender.new2,
  file=sprintf( "files_created/03a_BiasedGender.Rdat",
                number_patients )
)



