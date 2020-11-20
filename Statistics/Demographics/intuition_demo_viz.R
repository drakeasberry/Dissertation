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
vocab_size <- read_csv('analyze_data/output/intuition_vocab_sizes.csv')

# Plot Language Vocabulary Difference in lab segmentation experiment
all_demo <- vocab_diff_plt(vocab_size)
all_demo