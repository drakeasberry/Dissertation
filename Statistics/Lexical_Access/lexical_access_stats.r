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
lexical_data <- lexical_data_raw %>%
  mutate(prime_syl_structure = ifelse(numRevealed == 2, 'CV', 'CVC'),
         match = ifelse(prime_syl_structure == word_initial_syl, 'match', 'mismatch'),
         match_check = ifelse(matching == match, 'correct', 'error'),
         stress_word_initial = ifelse(stress_word_initial == 'yes', 'stressed','unstressed')) %>%
  select("partNum","lexicalRespCorr","lexicalRespRT","word","word_status","word_initial_syl","stress_word_initial","word_freq","Prime","prime_syl_structure","matching","expName","session","age","gender","birthCountry","placeResidence","education","preferLanguage","date")

# write out to miquel workspace
write_csv(lexical_data,'~/Desktop/working_diss_files/r-checking/lexical_data.csv')
 