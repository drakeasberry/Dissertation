#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(tidyverse)
library(kableExtra)
library(qwraps2)


# Soruce Scripts containing functions
source("../../Scripts_Dissertation/diss_dataviz_script.R")


# Read in all data from participants who met population criteria
demo_data <- read_csv('analyze_data/output/online_demo_data.csv')


# Counts by participant group
demo_data %>% 
  group_by(group) %>% 
  count()


# Dropped for error rates in experiment
# Monolingual Spanish Participants
mono_error_user <- read_csv('analyze_data/from_exp_analysis/44_eligible_online_mono_part.csv')


# L2 Spanish Learners
learner_error_user <- read_csv('analyze_data/from_exp_analysis/55_eligible_online_learners_part.csv')


# Combine all dropped participants
online_drop <- rbind(mono_error_user, learner_error_user) # n=21,(6 mono & 15 L2 speakers)


# Remove participants that did not perform well in experimental tasks
eligible_demo_data <- demo_data %>% 
  subset(., partNum %in% online_drop$partNum)


# Plot Demographics
# Spanish Vocabulary Size (Percent Correct)
esp_lextale(demo_data, "group", "lextale_esp_correct")
esp_lextale(eligible_demo_data, "group", "lextale_esp_correct")


# Spanish Vocabulary Size (Izura Calculation)
izura(demo_data, "group", "izura_score")
izura(eligible_demo_data, "group", "izura_score")


# Clean up environment
rm(demo_data, learner_error_user, mono_error_user, online_drop)


# Build summary table
dominance_summary <-
  list("Spanish Izura Score" = 
         list("mean (sd)" = ~ qwraps2::mean_sd(izura_score)),
       "Spanish Vocabulary Size" =
         list("mean (sd)" = ~ qwraps2::mean_sd(lextale_esp_correct))
  )              


# Create latex formattable table
by_lang <- summary_table(dplyr::group_by(eligible_demo_data, group),dominance_summary)
print(by_lang)


# Create image of tabled results
by_lang %>% 
  kbl(caption = "Descriptives") %>%
  kable_styling() %>% 
  pack_rows("Language Dominance", 1, 1) %>% 
  pack_rows("Spanish Vocabulary Size", 2, 2) %>%
  kable_classic(full_width = F, html_font = "Cambria")
