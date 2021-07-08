ggplot( fitted_logistic_model, aes(x=RECRUITMENT_neutral, y=pred_proba)) +
  geom_point() +
  geom_smooth(method = "glm", 
              method.args = list(family = "binomial"), 
              se = FALSE) 

### ROC Curve
recruitment_results$RECRUITMENT_Ethnicitybias <- relevel(recruitment_results$RECRUITMENT_Ethnicitybias, 
                                                         ref = "0")
levels(recruitment_results$RECRUITMENT_Ethnicitybias)

recruitment_results %>%
  roc_curve(truth = RECRUITMENT_Ethnicitybias, .pred_class) %>%
  autoplot()

#ROCR Curve
library(ROCR)
ROCRpred <- prediction(pred_class, recruitment_results$RECRUITMENT_Ethnicitybias)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))



###BOXPLOT
boxplot(recruitment_results~RECRUITMENT_Ethnicitybias, ylab="COUNT", xlab= "Recruited", 
        col="light blue",data = pred_class)
boxplot
