## This is the file that cleans the data for my replication project. 

## This is the session information used to create the figures, tables,
## and other statistics reported in the paper:

## Session info ----------------------------------
##  version  R version 4.0.2 (2020-06-22)
##  system   x86_64-apple-darwin17.0 (64-bit), macOS Mojave 10.14.6

## Packages --------------------------------------
##  package    * version 
##  tidyverse   1.3.1
##  janitor     2.1.0
##  rstanarm    2.21.1
##  stargazer   5.2.2
##  haven       2.4.1
##  modEvA      2.0
##  dplyr       1.0.5
##  statxp      0.2
##  gt          0.2.2
##  cowplot     1.1.1

library(tidyverse)
library(janitor)
library(rstanarm)
library(foreign)
library(stargazer)
library(arm)
library(haven)
library(modEvA)
library(dplyr)
library(xtable)
library(statxp)
library(gt)
library(gridExtra)
library(cowplot)

# I load the data from SPSS files from here:
# https://www.russellsage.org/datasets/economic-inequality-and-political-representation 

path = file.path("raw_data/DS1_v2_0.sav")
gilens = read_sav(path)

# I clean the dataset to exclude questions about policy changes that would
# require a constitutional amendment or Supreme Court ruling, proposed changes 
# that were partially but not fully adopted, and questions that lacked income 
# breakdowns. 1,779 questions from 1981–2002 remain for the analyses.

clean_gilens <- gilens %>%
  clean_names() %>%
  
  # I exclude the 27 questions where there is no income breakdown.
  
  filter(!is.na(pred50_sw)) %>%
  
  # I exclude the 57 questions where the policy was partially adopted.
  
  filter(outcome != 2.5 & outcome != 3.5 & outcome != 4.5) %>%

  # None of the remaining questions require a Constitutional amendment or a 
  # new Supreme Court ruling to bring about the proposed policy change - so
  # I do not need to apply an additional filter.
  
  # I turn the outcome variable into a dichotomous variable.
  
  mutate(policy_change = if_else(outcome > 0, 1, 0)) %>%
  
  # I calculate the net interest group alignment score by using the formula 
  # described in the paper.
  
  mutate(intgrp_align = (log(intgrp_stfav + (0.5 * intgrp_swfav) + 1)) - 
           (log(intgrp_stopp + (0.5 * intgrp_swopp) + 1))) %>%
  
  # I normalize the net interest group alignment score to be on a scale from 0 
  # to 1.
  
  mutate(intgrp_align_norm = range01(intgrp_align)) %>%
  
  # I use qlogis() to take the logit of the imputed percent of respondents at 
  # the 10th, 50th, and 90th income percentiles that favor the proposed policy 
  # change. I then use range01() to normalize my predictors to be on a scale 
  # from 0 to 1.
  
  mutate(pred10_norm = range01(qlogis(pred10_sw)),
         pred50_norm = range01(qlogis(pred50_sw)),
         pred90_norm = range01(qlogis(pred90_sw))) 

# I write a function to calculate the number of interest groups in favor of/
# opposed to proposed policy changes in each survey question.

add_scores <- function(df){
  
  df <- df %>%
    
    # I initialize 8 columns to track the number of mass-based and business
    # interest groups that are strongly in favor, somewhat in favor, somewhat
    # opposed, or strongly opposed to the policy change in each question.
    
    mutate(mass_intgrp_stfav = 0) %>%
    mutate(mass_intgrp_swfav = 0) %>%
    mutate(mass_intgrp_stopp = 0) %>%
    mutate(mass_intgrp_swopp = 0) %>%
    mutate(bus_intgrp_stfav = 0) %>%
    mutate(bus_intgrp_swfav = 0) %>%
    mutate(bus_intgrp_stopp = 0) %>%
    mutate(bus_intgrp_swopp = 0) 
  
  # I initialize two vectors to hold the indexes of the columns in clean_gilens
  # that hold the favor/oppose values for mass-based and business-oriented 
  # groups.
  
  mass_indexes = c(216, 217, 222, 224, 225, 230, 237, 248, 249, 256, 258)
  business_indexes = c(218, 219, 220, 221, 223, 226 ,227, 228, 229, 231,232, 233, 
                       234, 235, 236, 238, 239, 240, 241, 242, 243, 245, 247, 250, 
                       251, 252, 253, 254, 255)
  
  # I loop through each row of the dataframe.
  
  for (i in 1:nrow(df)) {
    
    # I loop through each of the interest group columns for each row.
    
    for(j in 216:258){
      
      # If the interest group is a mass-based interest group, I add to the
      # appropriate counter based on the value.
      
      if(j %in% mass_indexes){
        if (is.na(df[i,][j][[1]][1])) {
          df[i,][271] <- df[i,][271]*1
        } else if (df[i,][j][[1]][1] == 2) {
          df[i,][271] <- df[i,][271] + 1
        } else if (df[i,][j][[1]][1] == 1) {
          df[i,][272] <- df[i,][272] + 1
        } else if (df[i,][j][[1]][1] == -2) {
          df[i,][273] <- df[i,][273] + 1
        } else if (df[i,][j][[1]][1] == -1) {
          df[i,][274] <- df[i,][274] + 1
        } else {
          df[i,][271] <- df[i,][271]*1
        }
        
        # If the interest group is a business-oriented interest group, I add to 
        # the appropriate counter based on the value.
        
      } else if(j %in% business_indexes) {
        if (is.na(df[i,][j][[1]][1])) {
          df[i,][271] <- df[i,][271]*1
        } else if (df[i,][j][[1]][1] == 2) {
          df[i,][275] <- df[i,][275] + 1
        } else if (df[i,][j][[1]][1] == 1) {
          df[i,][276] <- df[i,][276] + 1
        } else if (df[i,][j][[1]][1] == -2) {
          df[i,][277] <- df[i,][277] + 1
        } else if (df[i,][j][[1]][1] == -1) {
          df[i,][278] <- df[i,][278] + 1
        } else {
          df[i,][271] <- df[i,][271]*1
        }
        
        # If the interest group is not a mass-based or business-oriented 
        # interest group, I do nothing.
        
      } else {
        df[i,][271] <- df[i,][271]*1
      }
      
    }
  }
  
  return(df)
  
}

clean_gilens <- add_scores(clean_gilens)

clean_gilens <- clean_gilens %>%
  
  # I calculate the net interest group alignment scores for mass-based interest
  # groups and business interest groups by using the formula described in the 
  # paper.
  
  mutate(mass_intgrp_align = (log(mass_intgrp_stfav + (0.5 * mass_intgrp_swfav) + 1)) - 
           (log(mass_intgrp_stopp + (0.5 * mass_intgrp_swopp) + 1)),
         bus_intgrp_align = (log(bus_intgrp_stfav + (0.5 * bus_intgrp_swfav) + 1)) - 
           (log(bus_intgrp_stopp + (0.5 * bus_intgrp_swopp) + 1))) %>%
  
  # I normalize the net interest group alignment scores for mass-based interest
  # groups and business interest groups to be on a scale from 0 to 1.
  
  mutate(mass_intgrp_align_norm = range01(mass_intgrp_align),
         bus_intgrp_align_norm = range01(bus_intgrp_align)) 

write_csv(clean_gilens, file = "clean_data/clean_gilens.csv")
