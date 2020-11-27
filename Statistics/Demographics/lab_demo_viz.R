#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(tidyverse)
library(kableExtra)
library(qwraps2)


# Soruce Scripts containing functions
source("../../Scripts_Dissertation/diss_dataviz_script.R")


# Read in data file
vocab_size <- read_csv('analyze_data/output/lab_vocab_sizes.csv')


# Plot Language Vocabulary Difference in lab segmentation experiment
vocab_diff_plt(vocab_size, "group", "diff")


# Segmentation higher errors and outlier participants
lab_part_remove <- read_csv('analyze_data/from_exp_analysis/45_eligible_lab_part.csv')


# Plot Language Vocabulary Difference for eligbile lab segmentation experiments
# This plot removes all participants removed due to experimental conditions
# Not paying attention, high error rates, technical difficulties, etc.
vocab_size %>% 
  subset(., partNum %in% lab_part_remove$partNum) %>% 
  vocab_diff_plt("group", "diff")


# Demographic Information Descriptions
# Load demographic data (Meets all population requirements)
demo_data <- read_csv('../Segmentation/analyze_data/demographics/46_lab_segmentation.csv')

# Remove participants that did not perform well in experimental tasks
eligible_demo_data <- demo_data %>% 
  subset(., partNum %in% lab_part_remove$partNum)


# Plot Demogrpahics
# Language Dominance
# Meet all population requirement
language_dominance(demo_data, "group", "lang_dominance") 
# Successfully and accurately completed the experiment
language_dominance(eligible_demo_data, "group", "lang_dominance")

# English Vocabulary Size
eng_lextale(demo_data, "group", "lextale_eng_correct")
eng_lextale(eligible_demo_data, "group", "lextale_eng_correct")

# Spanish Vocabulary Size
esp_lextale(demo_data, "group", "lextale_esp_correct")
esp_lextale(eligible_demo_data, "group", "lextale_esp_correct")


# Spanish Vocabulary Size (Izura Calculation)
izura(demo_data, "group", "izura_score")
izura(eligible_demo_data, "group", "izura_score")


# Clean up environment
rm(demo_data,lab_part_remove, vocab_size)


# Build summary table
dominance_summary <-
  list("Language Dominance" = 
         list("mean (sd)" = ~ qwraps2::mean_sd(lang_dominance)),
       "English Vocabulary Size" =
         list("mean (sd)" = ~ qwraps2::mean_sd(lextale_eng_correct)),
       "Spanish Vocabulary Size" =
         list("mean (sd)" = ~ qwraps2::mean_sd(lextale_esp_correct)),
       "Spanish Izura Score" = 
         list("mean (sd)" = ~ qwraps2::mean_sd(izura_score))
  )              


# Create latex formattable table
by_lang <- summary_table(dplyr::group_by(eligible_demo_data, group),dominance_summary)
print(by_lang)


# Create image of tabled results
by_lang %>% 
  kbl(caption = "Descriptives") %>%
  kable_styling() %>% 
  pack_rows("Language Dominance", 1, 1) %>% 
  pack_rows("English Vocabulary Size", 2, 2) %>%
  pack_rows("Spanish Vocabulary Size", 3, 3) %>%
  pack_rows("Spanish Izura Score", 4, 4) %>%
  kable_classic(full_width = F, html_font = "Cambria")
