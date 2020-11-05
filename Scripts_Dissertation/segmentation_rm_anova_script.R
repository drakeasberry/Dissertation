#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(readr)
library(tidyverse)
library(ggpubr)
library(rstatix)
library(afex)

# Convert the data into aggregated long form 
trans_long <-  function(data, group_col){
  script_my_data_long <- data %>% 
    group_by(!!!syms(group_col)) %>% 
    summarise(median_RTmsec = median(.data$segRespRTmsec),
              median_RTlog = median(.data$log_RT)) %>% 
    convert_as_factor(!!!syms(grouping))
  }

# Create named group subset
part_group <- function(data, grp_name){
  group <- data %>% 
    subset(., group == grp_name)
}

# populate named descriptive statistic
summary_stats <- function(data, group_col, variable, stat){
  stat_data <- data %>%   
    group_by(!!!syms(group_col)) %>% 
    get_summary_stats(!!sym(variable), type = stat) %>% 
    print()
}

# Check for outliers in data
outlier_chk <- function(data, grouping_col, variable){
  outlier <- data %>% 
    group_by(!!!syms(grouping_col)) %>% 
    identify_outliers(!!sym(variable)) %>% 
    print()  
}

# Check for normality in data
normality_chk <- function(data, grouping_col, variable){
  normality <- data %>% 
    group_by(!!!syms(grouping_col)) %>% 
    shapiro_test(!!sym(variable)) %>% 
    print()  
}