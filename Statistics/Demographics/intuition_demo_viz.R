#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(tidyverse)
library(kableExtra)
library(qwraps2)


# Soruce Scripts containing functions
source("../../Scripts_Dissertation/diss_dataviz_script.R")


# Read in data file
vocab_size <- read_csv('analyze_data/output/intuition_vocab_sizes.csv')


# Plot Language Vocabulary Difference in lab segmentation experiment
vocab_diff_plt(vocab_size, "group", "diff")


# Demographic Information Descriptions
# Load demographic data
demo_data <- read_csv('../Intuition/analyze_data/demographics/67_lab_intuition.csv')


# Plot Demogrpahics
# Language Dominance
language_dominance(demo_data, "group", "lang_dominance")


# English Vocabulary Size
eng_lextale(demo_data, "group", "lextale_eng_correct")


# Spanish Vocabulary Size (% Correct)
esp_lextale(demo_data, "group", "lextale_esp_correct")


# Spanish Vocabulary Size (Izura Calculation)
izura(demo_data, "group", "izura_score")


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
by_lang <- summary_table(dplyr::group_by(demo_data, group),dominance_summary)
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
