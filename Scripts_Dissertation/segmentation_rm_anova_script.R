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

seg_rm_anova <- function(filename){
  # Read in experimental dataset
  my_data <- read_csv(filename) 
  #my_data <- read_csv('analyze_data/output/Miquel_data.csv')
  summary(my_data) 
  
  my_data_long <- my_data %>% 
    group_by(partNum, group, word_status, word_initial_syl, matching) %>% 
    summarise(rt_ms = median(segRespRTmsec), rt_log = median(log_RT))
    #summarise(rt_ms = median(segRespRTmsec), rt_log = median(log_RT))
  
  # Subset data into learne groups
  learners <- my_data_long %>% 
    subset(., group == 'English')
  
  natives <- my_data_long %>% 
    subset(., group == 'Spanish')
  
  # Random sampling of each condition 
  set.seed(123)
  my_data_long %>% 
    sample_n_by(word_status, word_initial_syl, matching, size =1)
  learners %>% 
    sample_n_by(word_status, word_initial_syl, matching, size =1)
  natives %>% 
    sample_n_by(word_status, word_initial_syl, matching, size =1)
  
  learners <- learners %>% 
    mutate(condition = paste(word_initial_syl, matching, word_status, sep = "_")) %>% 
    convert_as_factor(partNum, condition, word_initial_syl, matching, word_status)
  print(learners)
  
  # Group data by word initial syllable, matching condition, and word status, 
  # then summary statistics for score
  learners %>% 
    group_by(word_initial_syl, matching, word_status) %>% 
    get_summary_stats(rt_ms, type = "mean_sd")
  
  learners %>% 
    group_by(word_initial_syl, matching, word_status) %>% 
    get_summary_stats(rt_log, type = "median_iqr") 
    
  
  
  # Visualize data
  bxp <- ggboxplot(learners, x = "word_initial_syl", y = "rt_ms", color = "matching",
                   palette = "jco", facet.by = "word_status", short.panel.labs = FALSE)
  print(bxp)
  
  # Check for outliers
  outliers <- learners %>% 
    group_by(word_initial_syl, matching, word_status) %>% 
    identify_outliers(rt_ms)
  print(outliers)
  
  # Check for normality
  normality <- learners %>% 
    group_by(word_initial_syl, matching, word_status) %>% 
    shapiro_test(rt_ms)
  print(normality)
  
  # Create QQ plot
  msec_rt <- ggqqplot(learners, "rt_ms", ggtheme = theme_bw()) +
    facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both")
  print(msec_rt)
  
  log_rt <- ggqqplot(learners, "rt_log", ggtheme = theme_bw()) +
    facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both")
  print(log_rt)
  
  print(glimpse(learners))
  
  
  # Compute three way repeated measures anova
  #m1 <- aov(rt_ms ~ word_initial_syl*matching*word_status + 
  #      Error(partNum/(word_initial_syl*matching*word_status)), 
  #    data = learners)
  #summary(m1)
  
  results <- aov_ez("partNum", "rt_log", learners, within = c("word_initial_syl", "matching", "word_status"))
  print(results)
}