### SECTION 03b_BiasEthnicity
### This section biases the simulated data based on the variable ethnicity.

### Assigning Gender bias to the dataset 
RandomData_Bias_Ethnicity = random_data.synthetic

### Defining when probability of YES/NO for each ethnicity
### and setting this in a function
white_bias <- 0.4
black_bias <- 0.1
indian_bias <- 0.1
pakistani_bias <- 0.1
chinese_bias <- 0.1
other_bias <- 0.1
notKown_bias <- 0.1

RandomData_Bias_Ethnicity_New <- RandomData_Bias_Ethnicity %>%
  #mutate(ethnic_group.char = as.character(ethnicity)) %>%
  mutate(ETHNICITY_Bias_RandomData = case_when(ethnicity == "1" ~ white_bias,
                                               ethnicity == "2" ~ black_bias,
                                               ethnicity == "3" ~ indian_bias,
                                               ethnicity == "4" ~ pakistani_bias,
                                               ethnicity == "5" ~ chinese_bias,
                                               ethnicity == "6" ~ other_bias,
                                               ethnicity == "7" ~ notKown_bias
  ))
#glimpse(SMR1_SimulatedDataComplete)

#SMR1_SimulatedDataBiasEthnicity

### Defining the functions of neutral recruitment and biased recruitment
recruitment_definition_neutral = defDataAdd( varname = "RECRUITMENT_Random_ETHNICITYneutral",
                                             dist    = "binary",
                                             formula = 0.5)

recruitment_definition_biased = defDataAdd( varname = "RECRUITMENT_Random_ETHNICITYbias",
                                            dist    = "binary",
                                            formula = "ETHNICITY_Bias_RandomData")


#SMR1_SimulatedDataBiasEthnicity

### Adding the columns of neutral and biased to the table
RandomData_Bias_Ethnicity.new1 = addColumns(recruitment_definition_neutral,
                                                  as.data.table(RandomData_Bias_Ethnicity_New))

RandomData_Bias_Ethnicity.new2 = addColumns(recruitment_definition_biased,
                                                  as.data.table(RandomData_Bias_Ethnicity.new1))

RandomData_Bias_Ethnicity.new2


### Transforming the binary values to Yes and No
#SMR1_SimulatedDataBiasEthnicity.new2 = SMR1_SimulatedDataBiasEthnicity.new2 %>% 
#mutate( RECRUITMENT_ETHNICITYneutral = recode( RECRUITMENT_ETHNICITYneutral,
"0"="Yes",
"1"="No") ) %>% 
  
  #mutate( RECRUITMENT_ETHNICITYbias = recode( RECRUITMENT_ETHNICITYbias,
  "0"="Yes",
  "1"="No") )
#SMR1_SimulatedDataBiasEthnicity.new2


### Saving the files
save (
  RandomData_Bias_Ethnicity.new2,
  file=sprintf( "files_created/05a_BiasedRandomDataEthnicity.Rdat",
                number_patients )
)

