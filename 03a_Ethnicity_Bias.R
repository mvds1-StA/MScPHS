### SECTION 03a_BiasEthnicity
### This section biases the simulated data based on the variable ethnicity.

### Assigning Gender bias to the dataset 
SMR1_SimulatedDataComplete_Ethnicity = SMR1_SimulatedDataComplete

### Defining when probability of YES/NO for each ethnicity
### and setting this in a function
white_bias <- 0.55
blackCaribbean_bias <- 0.05
black_bias <- 0.05
indian_bias <- 0.05
pakistani_bias <- 0.05
bangladeshi_bias <- 0.05
chinese_bias <- 0.05
other_bias <- 0.05
notKown_bias <- 0.05
refused_bias <- 0.05

SMR1_SimulatedDataBiasEthnicity <- SMR1_SimulatedDataComplete_Ethnicity %>%
  mutate(ETHNICITY_Bias = case_when(ETHNIC_GROUP == "00" ~ white_bias,
                                    ETHNIC_GROUP == "01" ~ blackCaribbean_bias,
                                    ETHNIC_GROUP == "03" ~ black_bias,
                                    ETHNIC_GROUP == "04" ~ indian_bias,
                                    ETHNIC_GROUP == "05" ~ pakistani_bias,
                                    ETHNIC_GROUP == "06" ~ bangladeshi_bias,
                                    ETHNIC_GROUP == "07" ~ chinese_bias,
                                    ETHNIC_GROUP == "08" ~ other_bias,
                                    ETHNIC_GROUP == "09" ~ notKown_bias,
                                    ETHNIC_GROUP == "10" ~ refused_bias
                               ))

### Defining the functions of neutral recruitment and biased recruitment
recruitment_definition.neutral = defDataAdd( varname = "RECRUITMENT_ETHNICITYneutral",
                                             dist    = "binary",
                                             formula = 0.5)
                                               
recruitment_definition.biased = defDataAdd( varname = "RECRUITMENT_ETHNICITYbias",
                                            dist    = "binary",
                                            formula = "ETHNICITY_Bias")

### Adding the columns of neutral and biased to the table
SMR1_SimulatedDataBiasEthnicity.new1 = addColumns(recruitment_definition.neutral,
                                               as.data.table(SMR1_SimulatedDataBiasEthnicity))

SMR1_SimulatedDataBiasEthnicity.new2 = addColumns(recruitment_definition.biased,
                                               as.data.table(SMR1_SimulatedDataBiasEthnicity.new1))


### Transforming the binary values to Yes and No
SMR1_SimulatedDataBiasEthnicity.new2 = SMR1_SimulatedDataBiasEthnicity.new2 %>% 
  mutate( RECRUITMENT_ETHNICITYneutral = recode( RECRUITMENT_ETHNICITYneutral,
                                              "0"="Yes",
                                              "1"="No") ) %>% 

  mutate( RECRUITMENT_ETHNICITYbias = recode( RECRUITMENT_ETHNICITYbias,
                                              "0"="Yes",
                                              "1"="No") ) %>% 
  
  mutate( SEX = recode( SEX,
                        "1"="Male",
                        "2"="Female") )

SMR1_SimulatedDataBiasEthnicity.new2


### Saving the files
save (
  SMR1_SimulatedDataBiasEthnicity.new2,
  file=sprintf( "files_created/03a_BiasedEthnicity.Rdat",
                number_patients )
)

