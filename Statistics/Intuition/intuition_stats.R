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
         sylRespRT = round(sylRespRT * 100,0),
         syl_structure = ifelse(str_length(corrSyl) == 2, 'CV', 'CVC')) %>%
  select("partNum", "group", "sylRespCorr","sylRespRT","syl_structure","corrSyl","word","expName","session","age","gender","birthCountry","placeResidence","education","preferLanguage","date")

rm(syllable_data_raw,syllable_dir,syllable_files)
# write out to miquel workspace
write_csv(syllable_data,'all_102_participants_intuition_data.csv')

# Need to create data set for demographics One line per participant
# demogrpahics_all.csv
# Create subset for Intuition Experiment Demographics
# intuition_demo.csv
# partID, LexTALE-ENG, LexTale-ESP, Bilingual Langauge Profile
# Store in Box > Intuition > Active > data > attributes
# Syllable Intuition Data by participant (only lab)
# Store in Box > Intuition > Active > data > input

syllable_data_no_heritage <- subset(syllable_data, syllable_data$group != "Childhood")
syllable_data_esp_part <- subset(syllable_data, syllable_data$group == "Spanish")
syllable_data_eng_part <- subset(syllable_data, syllable_data$group == "English")

syllable_data_no_heritage <- syllable_data_no_heritage %>% 
  select(-c("expName","session","age","gender","birthCountry","placeResidence","education","preferLanguage","date"))
write_csv(syllable_data_no_heritage, 'esp_eng_74_intuition.csv')
#write_csv(syllable_data_no_heritage, 'data.csv') # For PI Advisor
