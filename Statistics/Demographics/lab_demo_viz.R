#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(plyr)
library(readr)
library(tidyverse)
library(psych)
library(lattice)
library(tidyr)

# Create 'not in' function
'%ni%' <- Negate('%in%')

# Soruce Scripts containing functions
source("../../Scripts_Dissertation/segmentation_dataviz_script.R")

# Read in data file
vocab_size <- read_csv('analyze_data/output/lab_vocab_sizes.csv')

# Plot Language Vocabulary Difference in lab segmentation experiment
all_demo <- vocab_diff_plt(vocab_size)
all_demo


# Segmentation higher errors and outlier participants
lab_part_remove <- read_csv('analyze_data/45_eligible_lab_part.csv')

# Plot Language Vocabulary Difference for eligbile lab segmentation experiments
# This plot removes all participants removed due to experimental conditions
# Not paying attention, high error rates, technical difficulties, etc.
eligible_demo <- vocab_size %>% 
  subset(., partNum %in% lab_part_remove$partNum) %>% 
  vocab_diff_plt()
eligible_demo

