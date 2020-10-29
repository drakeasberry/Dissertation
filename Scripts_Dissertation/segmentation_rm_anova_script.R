#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(readr)
library(tidyverse)
library(ggpubr)
library(rstatix)
library(afex)

# Create 'not in' function
'%ni%' <- Negate('%in%')

# Surpress all readr messages by default
# https://www.reddit.com/r/rstats/comments/739vf6/how_to_turn_off_readrs_messages_by_default/
options(readr.num_columns = 0)

trans_long <-  function(data, group_col){
  script_my_data_long <- data %>% 
    group_by(!!!syms(group_col)) %>% 
    summarise(median_RTmsec = median(.data$segRespRTmsec),
              median_RTlog = median(.data$log_RT)) %>% 
    convert_as_factor(!!!syms(grouping))
  }

part_group <- function(data, grp_name){
  # Subset data into learne groups
  group <- data %>% 
    subset(., group == grp_name)
}

summary_stats <- function(data, group_col, variable, stat){
  stat_data <- data %>%   
    group_by(!!!syms(group_col)) %>% 
    get_summary_stats(!!sym(variable), type = stat) %>% 
    print()
}

outlier_chk <- function(data, grouping_col, variable){
  # Check for outliers
  outlier <- data %>% 
    group_by(!!!syms(grouping_col)) %>% 
    identify_outliers(!!sym(variable)) %>% 
    print()  
}


normality_chk <- function(data, grouping_col, variable){
  # Check for outliers
  normality <- data %>% 
    group_by(!!!syms(grouping_col)) %>% 
    shapiro_test(!!sym(variable)) %>% 
    print()  
}


seg_rm_anova <- function(data, grouping_col, id, variable){
  # run anova
  results <- aov_ez(id, variable, data, within = c(grouping_col)) %>% 
  print()
}