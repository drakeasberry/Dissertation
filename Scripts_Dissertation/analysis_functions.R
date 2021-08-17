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
    convert_as_factor(!!!syms(group_col))
  }

# This function is working because of the summarise pass (See quoting in my_stats function below)
trans_wide <-  function(data, group_col, summary_col){
  script_my_data_long <- data %>% 
    group_by(!!!syms(group_col)) %>% 
    summarise(!!!syms(summary_col)) %>% 
    convert_as_factor(!!!syms(group_col))
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

# Create Tables of Demographic Participant Data
counts <- function(data, grouping_col){
  data %>% 
    group_by(!!!syms(grouping_col)) %>%
    summarise(n = n())
}

# Statistic summary for numeric columns
my_stats <- function(data, grp_col, sum_col, stats){
  print(grp_col)
  data_count <- counts(data, grp_col)
  print(data_count)
  data %>% 
    group_by(!!!syms(grp_col), .drop = FALSE) %>%
    summarise(across(.cols = c(!!!syms(sum_col)), 
                     .fns = !!stats, na.rm = TRUE,
                     .names = "{col}_{fn}")) %>%
    {if(!is.null(grp_col)){ 
      left_join(., data_count, by = c(grp_col)) %>% 
            select(all_of(grp_col), n, everything())
    } else { 
        cbind(., data_count) %>% 
          select(n, everything())}
      }
}

# produce confidence intervals
conf_int <- function(data, grp_col, value){
  data %>%
  group_by(!!!syms(grp_col), .drop = FALSE) %>% 
  summarise(Mean = mean(!!!syms(value)),
            SD = sd(!!!syms(value)),
            N = n(),
            MOE_95 = qnorm(0.975)*SD/sqrt(N-1),
            LL = Mean - MOE_95,
            UL = Mean + MOE_95)
}