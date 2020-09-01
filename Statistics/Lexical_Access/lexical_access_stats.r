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
lexical_dir <- 'analyze_data/raw' #set path to directory
lexical_files <- list.files(path=lexical_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path

# read all csv files into a single tibble
lexical_data_raw <- ldply(lexical_files, read_csv)
write_csv(lexical_data_raw, 'all_58_lexical_items_raw.csv')

part_num_map <- read_csv('partNum_mapping.csv')
part_num_map <- part_num_map[grep('part[0-9]+', part_num_map$Participated_E2),] %>%
  subset(Participated_E1 != 'Exp 2 Only')
names(part_num_map)[2] = 'partNum'

group_map <- read_csv('../../Scripts_Dissertation/participant_group_map.csv')

lexical_data <- lexical_data_raw %>%
  full_join(part_num_map, by= 'partNum') %>%
  left_join(group_map, by = 'partNum') %>% 
  mutate(partNum = ifelse(is.na(Participated_E1) == TRUE, partNum, Participated_E1),
         prime_syl_structure = ifelse(numRevealed == 2, 'CV', 'CVC'),
         match = ifelse(prime_syl_structure == word_initial_syl, 'match', 'mismatch'),
         match_check = ifelse(matching == match, 'correct', 'error'),
         stress_word_initial = ifelse(stress_word_initial == 'yes', 'stressed','unstressed')) %>%
  select("partNum","group", "lexicalRespCorr","lexicalRespRT","word","word_status","word_initial_syl","stress_word_initial","word_freq","Prime","prime_syl_structure","matching","expName","session","age","gender","birthCountry","placeResidence","education","preferLanguage","date")


# write out to miquel workspace
write_csv(lexical_data, 'all_58_lexical_items_transformed.csv')

# drop heritage speaker group
lexical_data_no_heritage <- subset(lexical_data, lexical_data$group != "Childhood")
lexical_data_esp_part <- subset(lexical_data, lexical_data$group == "Spanish")
lexical_data_eng_part <- subset(lexical_data, lexical_data$group == "English")

lexical_data_no_heritage <- lexical_data_no_heritage %>% 
  select(-c("expName","session","age","gender","birthCountry","placeResidence","education","preferLanguage","date"))
write_csv(lexical_data_no_heritage, 'esp_eng_47_lexical_access.csv')
#write_csv(lexical_data_no_heritage, 'data.csv') # For PI Advisor

# Need to create data set for demographics One line per participant
# demogrpahics_all.csv
# Create subset for Lexical Access Experiment Demographics
# lexical_access_demo.csv
# partID, LexTALE-ENG, LexTale-ESP, Bilingual Langauge Profile
# Store in Box > Intuition > Active > data > attributes
# Lexical Access Data by participant (only lab)
# Store in Box > Laboratory > Active > data > input
 