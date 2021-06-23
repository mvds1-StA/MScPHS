### Sources of information
#http://www.sthda.com/english/wiki/correlation-matrix-a-quick-start-guide-to-analyze-format-and-visualize-a-correlation-matrix-using-r-software
#http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r


### Load the datafile
load("files_created/01C_SimulatedSMR1WRecruitment.Rdat")

### Calculating the correlations
library(Hmisc)
res <- rcorr(as.numeric(as.matrix(simulatedTrial), method = "pearson"))
ct <- cor.test(as.numeric(simulatedTrial$D.Prime, simulatedTrial$T.statistics, method = "pearson"))
ct
simulatedTrial
simulatedTrial[, round(cor(cbind((as.numeric(simulatedTrial$SEX, simulatedTrial$ETHNIC_GROUP, simulatedTrial$AGE_IN_YEARS)))), 1)]
round(res, 2)

res <-  cor(as.numeric(simulatedTrial$SEX, simulatedTrial$id, method = "pearson"))
cores


### Calculating correlations that work for sex and age, ethnic group is not working
corr_sex <- model.matrix(~ SEX - 1, simulatedTrial)
corr_ethnic <- model.matrix(~ ETHNIC_GROUP - 1, simulatedTrial)
corr_age <- model.matrix(~ AGE_IN_YEARS - 1, simulatedTrial)
cor(corr_sex, corr_age, method = "pearson")
cor(corr_sex, corr_age, method = "kendall")
cor(corr_sex, corr_ethnic)
cor(corr_age, corr_ethnic)

### Running the Shapiro Test on all variables within the simulatedTrial dataset
ST_SEX <- shapiro.test(as.numeric(simulatedTrial$SEX))
ST_ETHNICITY <- shapiro.test(as.numeric(simulatedTrial$ETHNIC_GROUP))
ST_AGE <- shapiro.test(as.numeric(simulatedTrial$AGE_IN_YEARS))
ST_RECRUITMENT <- shapiro.test(as.numeric(simulatedTrial$RECRUITMENT))

table_Shapiro <- matrix(c(ST_SEX, ST_AGE), nrow=1, ncol = 2)
colnames(table_Shapiro) <- c("Sex", "Age")
rownames(table_Shapiro) <- c("Shapiro Test")
table_Shapiro <- as.table(table_Shapiro)
table_Shapiro

### Scatterplots
library("ggpubr")
ggscatter(simulatedTrial, x = "AGE_IN_YEARS", y = "id", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Age in Years", ylab = "Number of participants")

ggscatter(tableSimulated_SMR1, x = "AGE_IN_YEARS", y = "id", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Age in Years", ylab = "Number of participants")

ggscatter(trial_data.synthetic, x = "age", y = "idnum", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Age in Years", ylab = "Number of participants")


### Histogram for simulated SMR1 (01c)
ggplot(simulatedTrial, aes(x = AGE_IN_YEARS, fill = SEX)) +
  geom_histogram(bins = 6, position = "dodge") +
  ggtitle("Histgoram of Age: Simulated SMR1") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlab("Age") + ylab("Number of Patients") +
  scale_fill_discrete(name = "Sex", labels = c("Female", "Male"))

### Histogram for non-simulated SMR1 (01b)
ggplot(table_SMR1, aes(x = AGE_IN_YEARS, fill = SEX)) +
  geom_histogram(bins = 6, position = "dodge") +
  ggtitle("Histgoram of Age: Non-simulated SMR1") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlab("Age") + ylab("Number of Patients") +
  scale_fill_discrete(name = "Sex", labels = c("Female", "Male"))

### Histogram for simulated random data (01a)
ggplot(trial_data.synthetic, aes(x = age, fill = gender)) +
  geom_histogram(bins = 6, position = "dodge") +
  ggtitle("Histgoram of Age: Random Simulated Data") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlab("Age") + ylab("Number of Patients") +
  scale_fill_discrete(name = "Sex", labels = c("Female", "Male"))


### Normal distribution for Age in Years
library("ggpubr")
#simulatedSMR1_Density_Age <- ggdensity(simulatedTrial$AGE_IN_YEARS, 
                            #main = "Density plot of Age in Years: Simulated SMR1",
                            #xlab = "Age in Years") +
                            #theme(plot.title = element_text(hjust = 0.5)) +
                            #geom_density(adjust=1.5, alpha=.4) 

#nonSimulatedSMR1_Density_Age <- ggdensity(table_SMR1$AGE_IN_YEARS, 
                                #main = "Density plot of Age in Years: Non-simulated SMR1",
                                #xlab = "Age in Years")+
                                #theme(plot.title = element_text(hjust = 0.5)) +
                                #geom_density(adjust=1.5, alpha=.4) 

#randomSimulated_Density_Age <- ggdensity(trial_data.synthetic$age, 
                                #main = "Density plot of Age in Years: Random Simulated Data",
                                #xlab = "Age in Years") +
                                #theme(plot.title = element_text(hjust = 0.5))  +
                                #geom_density(adjust=1.5, alpha=.4) 

plot(density(simulatedTrial$AGE_IN_YEARS), lty = 1, lwd=5, col="red", ylim=c(0,0.022), xlim=c(-50,150),
              xlab="Age in Years", ylab="Density", main="Age: Normal Distribution of the Three data sets")
lines(density(table_SMR1$AGE_IN_YEARS), lty = 2, lwd=5, col="green")
lines(density(trial_data.synthetic$age), lty = 3, lwd=5, col="blue")
legend(x="topright", legend = c("Simulated SMR1", "Non-Simulated SMR1", "Random Simulated Data"), 
          lty = c(1, 2, 3), col = c("red", "green", "blue"), lwd=5)


### Normal Distribution for Sex
plot(density(as.numeric(simulatedTrial$SEX)), lty = 1, lwd=5, col="red", ylim=c(0,0.022), xlim=c(-50,150),
     xlab="Gender", ylab="Density", main="Gender: Normal Distribution of the Three data sets")
lines(density(as.numeric(table_SMR1$SEX)), lty = 2, lwd=5, col="green")
lines(density(as.numeric(trial_data.synthetic$gender)), lty = 3, lwd=5, col="blue")
legend(x="topright", legend = c("Simulated SMR1", "Non-Simulated SMR1", "Random Simulated Data"), 
       lty = c(1, 2, 3), col = c("red", "green", "blue"), lwd=5)

