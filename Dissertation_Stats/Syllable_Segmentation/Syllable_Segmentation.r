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
  test_counter <- 1
  
  # for every item in the input vector, create specified number of rows needed to match length
  for(item in input_vector){
    if(i==1){
      out_vector <- sprintf(item,i:j) # creates vector on first run
    } else {
      out_vector <- append(out_vector, sprintf(item,i:j)) # appends to vector on subsequent runs
    }
    i <- i + iterator_size
    j <- j + iterator_size
    test_counter <- test_counter + 1
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
seg_dir = 'analyze_data' #set path to directory
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
  df_participant_transformed <- add_column(df_participant_raw, targetSyl= target_syllable_column, block= block_column, carriers= word_column)
  
  # subset to keep only columns necessary
  df_participant_transformed_correct_columns <- select(df_participant_transformed, fillerCarrier, block, carriers, targetSyl, segResp, segRespRT, partNum, session, age, gender, birthCountry, placeResidence, education, preferLanguage, date, expName)

  # Further subset to drop target syllable rows (48 in total)
  df_participant_clean <- filter(df_participant_transformed_correct_columns, fillerCarrier != 'targetSyl')
  
  # write transformed tibble to csv file
  transformed_dir <- file.path(seg_dir, 'transformed/') # create new directory name for updated files
  write_csv(df_participant_clean, file.path(transformed_dir, filename)) # write out corrected file to new directory
}

#---
# These items are only used in the Rstudio environment
# clean up items no longer needed from environment
rm(df_participant_clean, df_participant_transformed_correct_columns, df_participant_transformed, df_participant_raw,df_participant_modified, df_target_column, targets, blocks, target_syllable_column, block_column, word_column, csv_file, filename, seg_dir, seg_paths)
#---

# This block requires 'plyr' and 'readr'
# Segmentation Data Directory
#seg_dir <- transformed_dir #set path to directory
seg_files <- list.files(path=transformed_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path
#print(seg_files) # prints list of transformed files to be analyzed

# read in all the files into one data frame
# import multiple csv code modified from code posted at this link below:
# https://datascienceplus.com/how-to-import-multiple-csv-files-simultaneously-in-r-and-create-a-data-frame/
df_seg_data_raw = ldply(seg_files, read_csv)

#---
# These items are only used in the Rstudio environment
# clean up unnecessary items in environment
rm(seg_files)
#---

# Need library 'tidyverse' loaded
# Create subset of all critical items
df_seg_critical_raw <- subset(df_seg_data_raw, df_seg_data_raw$fillerCarrier == 'carrierItem')
print('Counts of responses to critical items')
print('1 = response and None = no response')
# Prints tibble showing all responses and frequency of response to critical items
count(df_seg_critical_raw, vars=segResp)

# Further subset critical data set to those that were NOT responded to by participants
df_seg_critical_wrong <- subset(df_seg_critical_raw, df_seg_critical_raw$segResp == 'None')
df_seg_critical_wrong #prints subsetted dataframe for all missed critical items

# Create a tibble of participants who incorrectly did not respond to critical item including number of errors
df_seg_critical_errors <- count(df_seg_critical_wrong, vars=partNum)
print('Counts of responses to critical items by participant')
print(as_tibble(df_seg_critical_errors), n=100) # n default is 10, but here it has been changed to 100 viewable rows

# Create a subset of all filler items
df_seg_filler_raw <- subset(df_seg_data_raw, df_seg_data_raw$fillerCarrier %ni% c('carrierItem', 'targetSyl'))
print('Counts of responses to filler items')
print('1 = response and None = no response')
# Prints tibble showing all responses and frequency of response to filler items
count(df_seg_filler_raw, vars=segResp)

# Further subset filler data set to those that were responded to by participants
df_seg_filler_wrong <- subset(df_seg_filler_raw, df_seg_filler_raw$segResp == 1)
df_seg_filler_wrong #prints subsetted dataframe for all filler items responded to

# Create a dataframe of participants who incorrectly responded to a filler item
df_seg_filler_errors <- count(df_seg_filler_wrong, vars=partNum)
print('Counts of responses to filler items by participant')
print(as_tibble(df_seg_filler_errors), n=100) # n default is 10, but here it has been changed to 100 viewable rows

# Find all participants who responded 43 or more times (>=10%) to filler items
# or missed more than 5 critical item (>= 10%), and they will be used to index later
high_seg_filler_responses <- c(which(df_seg_filler_errors$n >= 43.2))
high_seg_filler_responses #prints row numbers on filler data points excedding 43
high_miss_seg_critical_responses <- c(which(df_seg_critical_errors$n >= 4.8))
high_miss_seg_critical_responses #prints row numbers on critical data points excedding 5

# Create new tibbles based only on participants who committed a high number errors to fillers
tb_high_seg_filler_error_part <- df_seg_filler_errors[high_seg_filler_responses,] # creates tibble of participants and number of errors
tb_high_seg_filler_error_part #prints 2 column tibble of participant and error rate
tb_high_seg_critical_error_part <- df_seg_critical_errors[high_miss_seg_critical_responses,] # creates tibble of participants and number of errors
tb_high_seg_critical_error_part #prints 2 column tibble of participant and error rate

# Creates subset of wrong answers committed by high error rate participants
df_high_seg_errors_part <- df_seg_filler_wrong[df_seg_filler_wrong$partNum %in% tb_high_seg_filler_error_part$vars,]
df_high_seg_errors_part

# Creates subset of wrong answers commited by low error rate participants
df_low_seg_errors_part <- df_seg_filler_wrong[df_seg_filler_wrong$partNum %ni% tb_high_seg_filler_error_part$vars,]
df_low_seg_errors_part

# looks for too quick of response, anything below 200 ms
button_held_high <- c(which(df_high_seg_errors_part$segRespRT < .200))
print('prints responses given below 200ms')
button_held_high
tech_error_high <- df_high_seg_errors_part[button_held,7:6]
print('prints responses given below 200ms by participant number')
tech_error_high
length(tech_error_high$segRespRT)

button_not_held_high <- c(which(df_high_seg_errors_part$segRespRT >= .200))
length(button_not_held_high)

# Same as above but for low error committing participants
button_held_low <- c(which(df_low_seg_errors_part$segRespRT < .200))
button_held_low
tech_error_low <- df_low_seg_errors_part[button_held_low,7:6]
button_not_held_low <- c(which(df_low_seg_errors_part$segRespRT >= .200))

# Combine tibbles into new tibble
tb_tech_part_error <- full_join(count(tech_error_high, vars=partNum), count(df_high_seg_errors_part, vars=partNum), by = 'vars', copy = FALSE, suffix = c("_tech_errors", "_total_errors"))

# Add a column to new tibble with difference calculated to see real number of errors
tb_tech_error_removed <- add_column(tb_tech_part_error,non_technical_errors=tb_tech_part_error$n_total_errors - tb_tech_part_error$n_tech_errors,.after = 'n_total_errors')

# Test to see if any participant has still committed more than 10% error rate to filler items
re_investigate <- c(which(tb_tech_error_removed$non_technical_errors > 43))

# get numbers of each type of item
num_critical_items <- length(unique(df_seg_data_raw$partNum)) * 48 # number of participants \* 48 trial blocks \* 1 critical item per trial block
num_filler_items <- length(unique(df_seg_data_raw$partNum)) * 48 * 9 # number of participants \* 48 trial blocks \* 9 filler items per trial block
num_total_item <- num_critical_items + num_filler_items

if(num_total_item==length(df_seg_data_raw$fillerCarrier)){
  print('counts looks good: total counts match ')
} else {
  print('some counts are off, recheck data')
}

# Write out csv for Miquel Meeting
write_csv(df_seg_critical_raw,'~/Desktop/r-checking/segmentation_critical_items.csv')