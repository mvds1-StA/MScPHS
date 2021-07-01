### SECTION 03b_BiasEthnicity
### This section biases the simulated data based on the variable ethnicity.

### Assigning Gender bias to the dataset 
load("files_created/01d_SMR1wPostal.Rdat")


colnames(SMR1_SimulatedDataComplete)


### Defining when probability of YES/NO for each ethnicity
### and setting this in a function
white_bias <- 0.79
black_bias <- 0.03
indian_bias <- 0.03
pakistani_bias <- 0.03
chinese_bias <- 0.03
other_bias <- 0.03
notKown_bias <- 0.03

SMR1_SimulatedDataBiasEthnicity <- SMR1_SimulatedDataComplete %>%
  #mutate(ethnic_group.char = as.character(ETHNIC_GROUP)) %>%
  mutate(ETHNICITY_Bias = case_when(ETHNIC_GROUP == "00" ~ white_bias,
                                    ETHNIC_GROUP == "03" ~ black_bias,
                                    ETHNIC_GROUP == "04" ~ indian_bias,
                                    ETHNIC_GROUP == "05" ~ pakistani_bias,
                                    ETHNIC_GROUP == "07" ~ chinese_bias,
                                    ETHNIC_GROUP == "08" ~ other_bias,
                                    ETHNIC_GROUP == "09" ~ notKown_bias
                               ))
glimpse(SMR1_SimulatedDataComplete)

SMR1_SimulatedDataBiasEthnicity
  
### Defining the functions of neutral recruitment and biased recruitment
recruitment_definition.neutral = defDataAdd( varname = "RECRUITMENT_ETHNICITYneutral",
                                             dist    = "binary",
                                             formula = 0.5)
                                               
recruitment_definition.biased = defDataAdd( varname = "RECRUITMENT_ETHNICITYbias",
                                            dist    = "binary",
                                            formula = "ETHNICITY_Bias")

SMR1_SimulatedDataBiasEthnicity

### Adding the columns of neutral and biased to the table
SMR1_SimulatedDataBiasEthnicity.new1 = addColumns(recruitment_definition.neutral,
                                               as.data.table(SMR1_SimulatedDataBiasEthnicity))

SMR1_SimulatedDataBiasEthnicity.new2 = addColumns(recruitment_definition.biased,
                                               as.data.table(SMR1_SimulatedDataBiasEthnicity.new1))

SMR1_SimulatedDataBiasEthnicity.new2
