#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(plyr)
library(readr)
library(tidyverse)
library(psych)
library(lattice)
library(tidyr)
library(ggplot2)
library(kableExtra)
library(qwraps2)

# Create 'not in' function
'%ni%' <- Negate('%in%')

# Soruce Scripts containing functions
source("../../Scripts_Dissertation/segmentation_dataviz_script.R")

# Read in data file
vocab_size <- read_csv('analyze_data/output/intuition_vocab_sizes.csv')

# Plot Language Vocabulary Difference in lab segmentation experiment
all_demo <- vocab_diff_plt(vocab_size)
all_demo


# Demographic Information Descriptions
# Load demographic data
demo_data <- read_csv('analyze_data/demographics/67_lab_intuition.csv')


# Box plots
# Language Dominance
lang_dom <- ggplot(data = demo_data, 
                   aes(x = group,
                       y = lang_dominance)) +
  geom_boxplot(color = "purple", 
               width = 0.5,
               outlier.shape = 8, 
               outlier.size = 2) +
  geom_violin(color = "red", 
              fill = NA) +
  geom_jitter(width = 0.1) +
  ggtitle("Language Dominance") +
  xlab("Native Language Group") +
  ylab("Basic Language Profile Dominance Score")
lang_dom


# English Vocabulary Size
eng_vocab <- ggplot(data = demo_data, 
                    aes(x = group,
                        y = lextale_eng_correct)) +
  geom_boxplot(color = "purple", 
               width = 0.5,
               outlier.shape = 8, 
               outlier.size = 2) +
  geom_violin(color = "red", 
              fill = NA) +
  geom_jitter(width = 0.1) +
  ggtitle("English Vocabulary Size") +
  xlab("Native Language Group") +
  ylab("English Vocabulary % correct")
eng_vocab


# Spanish Vocabulary Size
esp_vocab <- ggplot(data = demo_data, 
                    aes(x = group,
                        y = lextale_esp_correct)) +
  geom_boxplot(color = "purple", 
               width = 0.5,
               outlier.shape = 8, 
               outlier.size = 2) +
  geom_violin(color = "red", 
              fill = NA) +
  geom_jitter(width = 0.1) +
  ggtitle("Spanish Vocabulary Size") +
  xlab("Native Language Group") +
  ylab("Spanish Vocabulary % correct")
esp_vocab

# Build summary table
dominance_summary <-
  list("Language Dominance" = 
         list("mean (sd)" = ~ qwraps2::mean_sd(lang_dominance)),
       "English Vocabulary Size" =
         list("mean (sd)" = ~ qwraps2::mean_sd(lextale_eng_correct)),
       "Spanish Vocabulary Size" =
         list("mean (sd)" = ~ qwraps2::mean_sd(lextale_esp_correct))
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
  kable_classic(full_width = F, html_font = "Cambria")

