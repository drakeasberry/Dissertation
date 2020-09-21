#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(plyr)
library(readr)
library(tidyverse)

# Create 'not in' function
'%ni%' <- Negate('%in%')

# Surpress all readr messages by default
# https://www.reddit.com/r/rstats/comments/739vf6/how_to_turn_off_readrs_messages_by_default/
options(readr.num_columns = 0)

# get all csv files from directory
syllable_dir <- 'analyze_data/raw' #set path to directory
syllable_files <- list.files(path=syllable_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path

group_map <- read_csv('../../Scripts_Dissertation/participant_group_map.csv')

# read all csv files into a single tibble
syllable_data_raw <- ldply(syllable_files, read_csv)
syllable_data <- syllable_data_raw %>%
  left_join(group_map, by = 'partNum') %>% 
  mutate(word = ifelse(is.na(word) == TRUE,syllabification,word),
         sylRespRTmsec = round(sylRespRT * 1000),
         syl_structure = ifelse(str_length(corrSyl) == 2, 'CV', 'CVC')) %>%
  rename(sylRespRTsec = sylRespRT) %>%
  drop_na("sylRespRTsec") %>% 
  select("partNum", "group", "sylRespCorr","sylRespRTsec","sylRespRTmsec","syl_structure","corrSyl","word")

# remove unecessary variables
rm(syllable_data_raw, syllable_dir, syllable_files)

# Check reaction times for range
syllable_data %>%
  summarise_at(vars(sylRespRTmsec), list(fastest = min, slowest = max)) 

# Check to make sure no single value columns exist
syllable_data %>%
  summarise_all(n_distinct)

# Keep this write statement
#write_csv(syllable_data,'all_102_participants_intuition_data.csv')

# Need to create data set for demographics One line per participant
# demogrpahics_all.csv
# Create subset for Intuition Experiment Demographics
# intuition_demo.csv
# partID, LexTALE-ENG, LexTale-ESP, Bilingual Langauge Profile
# Store in Box > Intuition > Active > data > attributes
# Syllable Intuition Data by participant (only lab)
# Store in Box > Intuition > Active > data > input

# Remove Heritage speaker group
syllable_data_no_heritage <- subset(syllable_data, syllable_data$group != "Childhood")

# Test to check counts when debugging
syllable_data_esp_part <- subset(syllable_data, syllable_data$group == "Spanish")
syllable_data_eng_part <- subset(syllable_data, syllable_data$group == "English")

#syllable_data_no_heritage <- syllable_data_no_heritage %>% 
#  select(-c("expName","session","age","gender","birthCountry","placeResidence","education","preferLanguage","date"))

# Check to make sure no single value columns exist
syllable_data_no_heritage %>%
  summarise_all(n_distinct)

# Write statement for file containing only necessary columns for intuition analysis
write_csv(syllable_data_no_heritage, 'esp_eng_74_intuition.csv')

# For PI Advisor
#write_csv(syllable_data_no_heritage, 'data.csv') 

rm(group_map, syllable_data_eng_part, syllable_data_esp_part)
