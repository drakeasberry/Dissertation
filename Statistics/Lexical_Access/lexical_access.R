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
lexical_dir = 'analyze_data/temp_data/segCols' #set path to directory
lexical_paths = list.files(path=lexical_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path
print(lexical_paths) # prints path with filenames

lexical_files <- list.files(path=lexical_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path
df_lexical_data_raw = ldply(lexical_files, read_csv)