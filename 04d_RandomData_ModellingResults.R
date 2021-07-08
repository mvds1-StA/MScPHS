OVERALL.variable_importance = LG_ethnicity_random_Biased$variable_importance %>%
  mutate( analysis = "NEUTRAL" ) %>% 
  bind_rows( MODERATE_PRIVATE_BIAS_NUMAPPT.out$variable_importance %>% 
               mutate( analysis = "PRIVATE_BIAS") ) %>% 
  bind_rows( MODERATE_PUBLIC_BIAS_NUMAPPT.out$variable_importance %>% 
               mutate( analysis = "PUBLIC_BIAS") )



ggplot( LG_ethnicity_random_Biased,
        aes( x=analysis,
             y=importance,
             colour=analysis) ) +
  geom_boxplot( ) +
  geom_jitter( ) +
  facet_wrap( ~variable, scales="free_y" ) +
  scale_colour_manual( values=analysis_colours ) +
  theme_bw()
