### SECTION 02b_Sex_QualityCheckBias
### Quality control check on the biased data for sex.

### Calculate the frequency of YES and NO
count(SMR1_SimulatedDataBiasGender.new2$RECRUITMENT_SEXneutral)
count(SMR1_SimulatedDataBiasGender.new2$RECRUITMENT_SEXbias)

### Calculate the YES and NO per sex group
tabyl(SMR1_SimulatedDataBiasGender.new2, SEX, RECRUITMENT_SEXbias)
tabyl(SMR1_SimulatedDataBiasGender.new2, SEX, RECRUITMENT_SEXneutral)
