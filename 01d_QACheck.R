### SECTION 01e_QACheck
### This section focuses on validating the build cohort on the quality
### and validity.

### Count of every gender and ethnic group BEFORE simulation
table(SMR1_data[c("SEX")])
table(SMR1_data[c("ETHNIC_GROUP")])

### Count of every gender and ethnic group AFTER simulation
table(SMR1_SimulatedDataComplete[c("SEX")])
table(SMR1_SimulatedDataComplete[c("ETHNIC_GROUP")])

### Histogram for simulated random data (01a): Age across sex
ggplot(random_data.synthetic, aes(x = age, fill = gender)) +
  geom_histogram(bins = 6, position = "dodge") +
  ggtitle("Histgoram of Age: Random Simulated Data") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlab("Age") + ylab("Number of Patients") +
  scale_fill_discrete(name = "Sex", labels = c("Female", "Male"))

### Histogram for non-simulated SMR1 (01b): : Age across sex
ggplot(SMR1_data, aes(x = AGE_IN_YEARS, fill = SEX)) +
  geom_histogram(bins = 6, position = "dodge") +
  ggtitle("Histgoram of Age: Non-simulated SMR1") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlab("Age") + ylab("Number of Patients") +
  scale_fill_discrete(name = "Sex", labels = c("Female", "Male"))

### Histogram for simulated SMR1 (01c): : Age across sex
ggplot(SMR1_SimulatedDataComplete, aes(x = AGE_IN_YEARS, fill = SEX)) +
  geom_histogram(bins = 6, position = "dodge") +
  ggtitle("Histgoram of Age: Simulated SMR1") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlab("Age") + ylab("Number of Patients") +
  scale_fill_discrete(name = "Sex", labels = c("Female", "Male"))


### Normal distribution for Age in Years
plot(density(SMR1_SimulatedDataComplete$AGE_IN_YEARS), lty = 1, lwd=5, col="red", ylim=c(0,0.032), xlim=c(-50,150),
              xlab="Age in Years", ylab="Density", main="Age: Normal Distribution of the Three data sets")
lines(density(SMR1_data$AGE_IN_YEARS), lty = 2, lwd=5, col="green")
lines(density(random_data.synthetic$age), lty = 3, lwd=5, col="blue")
legend(x="topright", legend = c("Simulated SMR1", "Non-Simulated SMR1", "Random Simulated Data"), 
          lty = c(1, 2, 3), col = c("red", "green", "blue"), lwd=2)

