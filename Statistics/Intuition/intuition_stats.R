#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(plyr)
library(readr)
library(tidyverse)


# Create and store functions 
# create 'not in' function
'%ni%' <- Negate('%in%')

# create logit tranformation function
logitTrans <- function(x) { log(x/(1-x)) }

# Surpress all readr messages by default
# https://www.reddit.com/r/rstats/comments/739vf6/how_to_turn_off_readrs_messages_by_default/
options(readr.num_columns = 0)

options(qwraps2_markup = "latex")

# Load dataframe containing participant number and group affiliation 
group_map <- read_csv('../../Scripts_Dissertation/participant_group_map.csv')

# Get all csv files from directory
# Set file directory path
syllable_dir <- 'analyze_data/raw' 

# Create vector of all files with path
syllable_files <- list.files(path=syllable_dir, pattern = '*.csv', full.names = TRUE)

# Read all csv files into a single dataframe
syllable_data_raw <- ldply(syllable_files, read_csv)


# Prepare raw data for anaylsis
# Create new dataframe based off raw input dataframe
syllable_data <- syllable_data_raw %>%
  left_join(group_map, by = 'partNum') %>% # add group as dataframe column
  # combine experiment words into signle column
  mutate(word = ifelse(is.na(word) == TRUE, syllabification, word),
         sylRespRTmsec = round(sylRespRT * 1000), # create new column with RT in (ms)
         # create new column containing syllable structure
         syl_structure = ifelse(str_length(corrSyl) == 2, 'CV', 'CVC')) %>%
  rename(sylRespRTsec = sylRespRT) %>% #rename old column to sylRespRTsec
  # dropped 4 no response items from part065 and 1 from part072 (Experimental error caused this)
  drop_na("sylRespRTsec") %>%
  # select columns to keep in dataframe
  select("partNum", "group", "sylRespCorr", "sylRespRTsec", "sylRespRTmsec", "syl_structure",
         "corrSyl", "word")

# Remove unnecessary elements from R environment
rm(group_map, syllable_data_raw, syllable_dir, syllable_files)

# Check reaction times for range
syllable_data %>%
  summarise_at(vars(sylRespRTmsec), list(fastest = min, slowest = max)) 

# Check to make sure no single value columns exist
syllable_data %>%
  summarise_all(n_distinct)

# Remove Heritage speaker group
# remove heritage participants in group "Childhood"
syllable_data_no_heritage <- subset(syllable_data, syllable_data$group != "Childhood")

# Check to make sure no single value columns exist
syllable_data_no_heritage %>%
  summarise_all(n_distinct)

# Remove unnecessary elements from R environment
rm(syllable_data)

# Write statement for file containing only necessary columns for intuition analysis
write_csv(syllable_data_no_heritage, 'analyze_data/output/67_intuition.csv')
# For PI Advisor naming convention in secure cloud storage
#write_csv(syllable_data_no_heritage, 'analyze_data/output/data.csv') 


# Create new long form dataframe with new columns needed for analysis
mydata_long <- syllable_data_no_heritage %>%
  # keep participant, group and syllable structure column for summary
  group_by(partNum, group, syl_structure) %>%
  # add new column with percent correct by participant and syllable structure
  summarise(correct = mean(sylRespCorr)) %>%
  # transform current data in correct column from 1 to 0.9999 for regression
  mutate(correct = ifelse(correct == 1, 0.9999, correct),
         # apply logit function to percent correct column and store in new column
         logit = logitTrans(correct))

# Write long form dataframe to csv
write_csv(mydata_long, 'analyze_data/output/data_long.csv')
