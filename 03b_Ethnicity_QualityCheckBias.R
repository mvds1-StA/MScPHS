### SECTION 03b_Ethnicity_QualityCheckBias
### Quality control check on the biased data for ethnicity.

### Calculate the overall YES and NO
count(SMR1_SimulatedDataBiasEthnicity.new2$RECRUITMENT_ETHNICITYneutral)
count(SMR1_SimulatedDataBiasEthnicity.new2$RECRUITMENT_ETHNICITYbias)

### Calculate YES and NO per ethnicity group
tabyl(SMR1_SimulatedDataBiasEthnicity.new2, ETHNIC_GROUP, RECRUITMENT_ETHNICITYbias)
tabyl(SMR1_SimulatedDataBiasEthnicity.new2, ETHNIC_GROUP, RECRUITMENT_ETHNICITYneutral)
