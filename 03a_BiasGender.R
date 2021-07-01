### SECTION 03a_BiasGender
### This section biases the simulated data based on the variable gender.

### Assigning Gender bias to the dataset 
load("files_created/01d_SMR1wPostal.Rdat")

### Defining when probability of YES/NO for each gender
### and setting this in a function
female_bias <- 0.7
male_bias <- 0.3

SMR1_SimulatedDataBiasGender <- SMR1_SimulatedDataComplete %>%
  mutate(SEX_Bias = fcase(SEX == 1, female_bias,
                          SEX == 2, male_bias))

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

SMR1_SimulatedDataBiasGender.new2
