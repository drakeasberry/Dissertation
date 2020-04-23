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

# Create new vectors to use in transformations
row_to_column <- function(iterator_size, input_vector){
  i <- 1 # r indexing start at 1, not 0
  j <- iterator_size # how many rows need to be created
  counter <- 1
  
  # for every item in the input vector, create specified number of rows needed to match length
  for(item in input_vector){
    if(i==1){
      out_vector <- sprintf(item,i:j) # creates vector on first run
    } else {
      out_vector <- append(out_vector, sprintf(item,i:j)) # appends to vector on subsequent runs
    }
    i <- i + iterator_size
    j <- j + iterator_size
    counter <- counter + 1
  }
  return(out_vector)
}

# creates word transformation from row to column
words_to_column <- function(input_tibble, iterator_size, input_vector){
  i <- 1 # r indexing start at 1, not 0
  j <- iterator_size # how many rows need to be created
  
  # for every item in the input vector, create specified number of rows needed to match length
  for(item in input_vector){
    carriers <- input_tibble[i:j,item]
    if(i==1){
      out_vector <- as.character(carriers[[item]]) # creates vector on first run
    } else {
      out_vector <- append(out_vector, as.character(carriers[[item]])) # appends to vector on subsequent runs
    }
    i <- i + iterator_size
    j <- j + iterator_size
  }
  return(out_vector)
}

# get all csv files from directory
seg_dir = 'analyze_data/raw' #set path to directory
seg_paths = list.files(path=seg_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path
#print(seg_paths) # prints path with filenames

# transforms data structure for use in analysis
for(csv_file in seg_paths){
  filename <- basename(csv_file)
  # Each trial loop runs one participant
  #print(csv_file) # print out filename for segmentation analysis
  df_participant_raw <- read_csv(csv_file) #reads in raw data file from analyze_data directory

  # Create subset to build vectors for transformation
  df_participant_modified <- as_tibble(select(df_participant_raw, block01:block48)) #includes only trial columns (48)
  
  # subset dataframe to get 'targetSyl' row only once
  df_target_column <- filter(df_participant_modified, row_number() == 11L)
  
  # create vectors to transform syllable targets and block trial numbers
  targets <- as.character(df_target_column) # creates vector of all targets
  blocks <- as.character(colnames(df_participant_modified)) # creates a vector of all block labels
  
  # Call function to expand vectors to match dataframe length
  target_syllable_column <- do.call('row_to_column',list(11,targets)) # converts target vector column with appropriate length
  block_column <- do.call('row_to_column',list(11,blocks)) # converts block label vector column with appropriate length
  word_column <- do.call('words_to_column',list(df_participant_raw, 11, blocks)) # grabs all words and puts them into one column
  
  # Create new dataframe with three new transformed columns
  df_participant_transformed <- add_column(df_participant_raw, targetSyl= target_syllable_column, block= block_column, word= word_column)
  
  # subset to keep only columns necessary
  df_participant_transformed_correct_columns <- select(df_participant_transformed, fillerCarrier, block, word, targetSyl, segResp, segRespRT, partNum, session, age, gender, birthCountry, placeResidence, education, preferLanguage, date, expName)

  # Further subset to drop target syllable rows (48 in total)
  df_participant_clean <- filter(df_participant_transformed_correct_columns, fillerCarrier != 'targetSyl')

  # write transformed tibble to csv file
  transformed_dir <- file.path(seg_dir, '../transformed/') # create new path to transformed directory name for updated files
  write_csv(df_participant_clean, file.path(transformed_dir, filename)) # write out corrected file to new directory
}

# This block requires 'plyr' and 'readr'
# Segmentation Data Directory
seg_files <- list.files(path='analyze_data/transformed/', pattern = '*.csv', full.names = TRUE) #list all the files with path
#print(seg_files) # prints list of transformed files to be analyzed

# read in all the files into one data frame
# import multiple csv code modified from code posted at this link below:
# https://datascienceplus.com/how-to-import-multiple-csv-files-simultaneously-in-r-and-create-a-data-frame/
df_raw_seg <- ldply(seg_files, read_csv)

#---
# These items are only used in the Rstudio environment
# Clean up unnecessary items in environment
#rm(df_participant_clean, df_participant_transformed_correct_columns,
   #df_participant_transformed, df_participant_raw,df_participant_modified,
   #df_target_column, targets, blocks, target_syllable_column, block_column,
   #word_column, csv_file, filename, seg_dir, seg_paths, seg_files, transformed_dir)
rm(csv_file, seg_dir, seg_paths, seg_files)
#---

# Create a new dataframe to join to participant data needed for analysis
# Get all condition csv files copied from processed experiment directory
join_dir = 'analyze_data' #set path to directory
join_paths = list.files(path=join_dir, pattern = '*[ABCD].csv', full.names = TRUE) #list all the files with path
#print(join_paths) # prints path with filenames

# Each trial loop runs one condition A,B,C or D
for(csv_condition in join_paths){
  filename <- basename(csv_condition)
  cond <- str_sub(filename,8,8)
  df_raw_cond <- read_csv(csv_condition, col_names = FALSE) #reads in raw data file from analyze_data directory
  df_items <- df_raw_cond[-c(1, 2, 3),] #remove first three rows

  i <- 1
  while (i <= 3) {
    row <- paste('row',i, sep='_')
    row_tran <- paste('row_tran',i, sep='_')
    col = filter(df_raw_cond, row_number() == i)
    assign(row_tran, row_to_column(10,col[3:50]))
    i = i + 1
  }

  j <- 2 # start at 2 to avoid repition of column names as data
  col_labels <- df_items[,2]
  names(col_labels) <- 'fillerCarrier'

  while (j <= length(df_items)) {
    exp_words <- df_items[,j]
    names(exp_words) <- 'word'

    if (j == 2){
      out_tibble <- col_labels
    } else if (j==3) {
      out_tibble = bind_cols(out_tibble, exp_words)
    } else {
      temp_tibble = bind_cols(col_labels, exp_words)
      out_tibble <- rbind(out_tibble, temp_tibble)
    }
    df_cond_tran <- paste(row_tran,filename,sep = '_')
    j = j + 1
  }
  assign(df_cond_tran, tibble(block = row_tran_1, word_status = row_tran_2, target_syl = row_tran_3))
  out_tibble <- add_column(out_tibble, condition = cond)
  assign(filename, out_tibble)
}

all_conditions <- rbind(expCondA.csv, expCondB.csv, expCondC.csv, expCondD.csv)
all_data_tranformations <- rbind(row_tran_3_expCondA.csv,row_tran_3_expCondB.csv,row_tran_3_expCondC.csv,row_tran_3_expCondD.csv)
exp_joiner <- all_data_tranformations %>% 
  bind_cols(all_conditions) %>%
  mutate(word_status = ifelse(grepl('Real[0-9]+',word_status),'word','nonword'))

#---
# These items are only used in the Rstudio environment
# Clean up unnecessary items in environment
rm(all_conditions, all_data_tranformations, col, df_cond_tran, df_raw_cond, df_items, exp_words, expCondA.csv,
   expCondB.csv, expCondC.csv, expCondD.csv, col_labels, out_tibble, row_tran_3_expCondA.csv, row_tran_3_expCondB.csv,
   row_tran_3_expCondC.csv, row_tran_3_expCondD.csv, temp_tibble, csv_condition, filename, i, j, row, row_tran, row_tran_1,
   row_tran_2, row_tran_3, cond)
#---

# Read in experiment files contatining information about experimental items needed
# for analysis and will be joined to participant data
keep_columns <- c('word','word_initial_syl','word_freq') # keep only these columns

# Build critical items table
exp_error <- tibble(word='permsio',word_initial_syl='CVC') # typo in experimental item added to list
df_critical <- read_csv('analyze_data/Critical_Items.csv')
df_critical <- df_critical %>%
  subset(Exp_Prac=='Experimental') %>%
  select(keep_columns)
# Bind error row and experimental items
df_critical <- rbind.fill(df_critical, exp_error)

# Build filler tables
df_rw_filler <- read_csv('analyze_data/RW_Filler_Items.csv')
df_pw_filler <- read_csv('analyze_data/PW_Filler_Items.csv')

# combine pseudo/real word tiblles and drop unnecessary columns
df_filler <- rbind.fill(df_rw_filler, df_pw_filler) %>%
  select(keep_columns)

# Combine potential fillers and actual critical items into a single tibble
corpus_joiner <- rbind(df_critical, df_filler)

# Join experimenatl condition with potentials from critical/filler joins
complete_joiner <- exp_joiner %>%
  inner_join(corpus_joiner, by = 'word') %>%
  distinct() %>%
  select(keep_columns,'word_status')

# I should probably write this out to a new file.....
write_csv(complete_joiner,'~/Desktop/working_diss_files/r-checking/join_table.csv')


# Join table with experimental results from participants
seg_data_join <- df_raw_seg %>%
  inner_join(complete_joiner, by = 'word') %>%
  distinct() %>% # remove duplicates
  mutate(exp_word_type = ifelse(fillerCarrier =='carrierItem','carrier','filler'),
         target_syl_structure = ifelse(str_length(targetSyl)==2,'CV','CVC'),
         matching = ifelse(word_initial_syl == target_syl_structure,'matching','mismatching')) %>%
  select("partNum","segResp","segRespRT","word","word_status","word_initial_syl","word_freq","targetSyl","target_syl_structure","matching", "exp_word_type","expName","block","session","age","gender","birthCountry","placeResidence","education","preferLanguage","date")

write_csv(seg_data_join,'~/Desktop/working_diss_files/r-checking/segmentation_data.csv')
#---
# These items are only used in the Rstudio environment
# Clean up unnecessary items in environment
rm(df_critical, df_rw_filler, df_pw_filler, exp_error, complete_joiner, corpus_joiner,
   df_filler, exp_joiner, df_raw_seg, join_dir, join_paths, keep_columns)
#---

# Need library 'tidyverse' loaded
# Create subset of all critical items
#print('Counts of responses to critical items')
#print('1 = response and None = no response')
seg_critical <- subset(seg_data_join, seg_data_join$exp_word_type == 'carrier')
# Prints tibble showing all responses and frequency of response to critical items
#count(seg_critical, vars=segResp)
write_csv(seg_critical,'~/Desktop/working_diss_files/r-checking/critical_items.csv')

# Further subset critical data set to those that were NOT responded to by participants
seg_critical_misses <- subset(seg_critical, seg_critical$segResp == 'None')
write_csv(seg_critical_misses,'~/Desktop/working_diss_files/r-checking/critical_misses.csv')

# Create a tibble of participants who incorrectly did not respond to critical item including number of errors
df_seg_critical_errors <- count(seg_critical_misses, vars=partNum)
#print('Counts of responses to critical items by participant')
#print(as_tibble(df_seg_critical_errors), n=100) # n default is 10, but here it has been changed to 100 viewable rows

# Create a subset of all filler items
seg_filler <- subset(seg_data_join, seg_data_join$exp_word_type != 'carrier')
#print('Counts of responses to filler items')
#print('1 = response and None = no response')
# Prints tibble showing all responses and frequency of response to filler items
#count(seg_filler, vars=segResp)
write_csv(seg_filler,'~/Desktop/working_diss_files/r-checking/filler_items.csv')

# Further subset filler data set to those that were responded to by participants
seg_filler_responses <- subset(seg_filler, seg_filler$segResp == 1)
write_csv(seg_filler_responses,'~/Desktop/working_diss_files/r-checking/filler_responses.csv')

# Create a dataframe of participants who incorrectly responded to a filler item
df_seg_filler_errors <- count(seg_filler_responses, vars=partNum)
#print('Counts of responses to filler items by participant')
#print(as_tibble(df_seg_filler_errors), n=100) # n default is 10, but here it has been changed to 100 viewable rows

# Find all participants who responded 43 or more times (>=10%) to filler items
# or missed more than 5 critical item (>= 10%), and they will be used to index later
high_seg_filler_responses <- c(which(df_seg_filler_errors$n >= 43.2))
high_seg_filler_responses #prints row numbers on filler data points excedding 43
high_miss_seg_critical_responses <- c(which(df_seg_critical_errors$n >= 4.8))
high_miss_seg_critical_responses #prints row numbers on critical data points excedding 5

# Create new tibbles based only on participants who committed a high number errors to fillers
tb_high_seg_filler_error_part <- df_seg_filler_errors[high_seg_filler_responses,] # creates tibble of participants and number of errors
#tb_high_seg_filler_error_part #prints 2 column tibble of participant and error rate
tb_high_seg_critical_error_part <- df_seg_critical_errors[high_miss_seg_critical_responses,] # creates tibble of participants and number of errors
#tb_high_seg_critical_error_part #prints 2 column tibble of participant and error rate

# Creates subset of wrong answers committed by high error rate participants
df_high_seg_errors_part <- seg_filler_responses[seg_filler_responses$partNum %in% tb_high_seg_filler_error_part$vars,]
#df_high_seg_errors_part

# Creates subset of wrong answers commited by low error rate participants
df_low_seg_errors_part <- seg_filler_responses[seg_filler_responses$partNum %ni% tb_high_seg_filler_error_part$vars,]
#df_low_seg_errors_part

# looks for too quick of response, anything below 200 ms
button_held_high <- c(which(df_high_seg_errors_part$segRespRT < .200))
#print('prints responses given below 200ms')
#button_held_high
tech_error_high <- df_high_seg_errors_part[button_held_high,c('partNum','segRespRT')]
#print('prints responses given below 200ms by participant number')
#tech_error_high
#length(tech_error_high$segRespRT)

button_not_held_high <- c(which(df_high_seg_errors_part$segRespRT >= .200))
#length(button_not_held_high)

# Same as above but for low error committing participants
button_held_low <- c(which(df_low_seg_errors_part$segRespRT < .200))
#button_held_low
tech_error_low <- df_low_seg_errors_part[button_held_low,c('partNum','segRespRT')]
button_not_held_low <- c(which(df_low_seg_errors_part$segRespRT >= .200))

# Combine tibbles into new tibble
tb_tech_part_error <- full_join(count(tech_error_high, vars=partNum), count(df_high_seg_errors_part, vars=partNum), by = 'vars', copy = FALSE, suffix = c("_tech_errors", "_total_errors"))

# Add a column to new tibble with difference calculated to see real number of errors
# This shows the number of errors committed by participant NOT due to technical issues
tb_tech_error_removed <- add_column(tb_tech_part_error,non_technical_errors=tb_tech_part_error$n_total_errors - tb_tech_part_error$n_tech_errors,.after = 'n_total_errors')

# Test to see if any participant has still committed more than 10% error rate to filler items
# If investigate has participants, they need to be removed for higher error rates,
# If investigate is empty, this is a positive.
investigate <- c(which(tb_tech_error_removed$non_technical_errors > 43))
if(length(investigate) == 0){
  print('No issues here')
  rm(df_high_seg_errors_part,df_low_seg_errors_part, tb_high_seg_critical_error_part,
     tb_high_seg_filler_error_part,tb_tech_error_removed,tb_tech_part_error,
     tech_error_high,tech_error_low, button_held_high, button_held_low,
     button_not_held_high, button_not_held_low, high_miss_seg_critical_responses, 
     high_seg_filler_responses, df_seg_critical_errors, df_seg_filler_errors, investigate)
  } else{
    print('See who has too many errors:')
    }
