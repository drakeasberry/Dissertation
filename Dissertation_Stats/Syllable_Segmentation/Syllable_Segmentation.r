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
    #print(test_counter)
    #print(input_vector)
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
segDir = 'analyze_data' #set path to directory
segPaths = list.files(path=segDir, pattern = '*.csv', full.names = TRUE) #list all the files with path
#print(segPaths) # prints path with filenames

# transforms data structure for use in analysis
for(csv_file in segPaths){
  filename <- basename(csv_file)
  # Each trial loop runs one participant
  #print(csv_file) # print out filename for segmentation analysis
  participant <- read_csv(csv_file)
  mod_part <- as_tibble(select(participant, block01:block48))
  
  # include header 'targetSyl'
  target_column <- filter(mod_part, row_number() == 11L)
  
  # create vectors to transform syllable targets and block trial numbers
  targets <- as.character(target_column) # creates vector of all targets
  blocks <- as.character(colnames(mod_part)) # creates a vector of all block labels
  
  # Call function to expand vectors to match tibble length
  target_syllable_column <- do.call('row_to_column',list(11,targets)) # converts target vector column with appropriate length
  block_column <- do.call('row_to_column',list(11,blocks)) # converts block label vector column with appropriate length
  word_column <- do.call('words_to_column',list(participant,11,blocks)) # grabs all words and puts them into one column
  
  # add new vectors to existing tibble with column heading
  participant <- add_column(participant, targetSyl= target_syllable_column, block= block_column, carriers= word_column)
  
  # subset to keep only columns necessary
  participant <- select(participant, fillerCarrier,block,carriers,targetSyl,segResp,segRespRT,partNum,session,age,gender,birthCountry,placeResidence,education,preferLanguage,date,expName)
  participant <- filter(participant, fillerCarrier != 'targetSyl') # drops target syllable row
  
  # write transformed tibble to csv file
  transformed_directory <- file.path(segDir,'transformed/') # create new directory name for updated files
  #writeDir <- dir.create(transformed_directory, showWarnings = FALSE) # create new directory for updated files
  write_csv(participant,file.path(transformed_directory,filename)) # write out corrected file to new directory
}

#---
# These items are only used in the Rstudio environment
# clean up items no longer needed from environment
#rm(mod_part, target_column,targets, blocks, target_syllable_column, block_column, word_column, csv_file, filename, segDir, writeDir, segPaths, participant)
#---

# This block requires 'plyr' and 'readr'
# Segmentation Data Directory
segDir <- transformed_directory #set path to directory
segFiles <- list.files(path=segDir, pattern = '*.csv', full.names = TRUE) #list all the files with path
#print(segFiles) # prints list of transformed files to be analyzed

# read in all the files into one data frame
# import multiple csv code modified from code posted at this link below:
# https://datascienceplus.com/how-to-import-multiple-csv-files-simultaneously-in-r-and-create-a-data-frame/
segData = ldply(segFiles, read_csv)

#---
# These items are only used in the Rstudio environment
# clean up unnecessary items in environment
# rm(segDir,segFiles)
#---

# Need library 'tidyverse' loaded
# Create subset of all critical items
df_seg_critical <- subset(segData,segData$fillerCarrier == 'carrierItem')
print('Counts of responses to critical items')
count(df_seg_critical, vars=segResp)
#tb_critical <- as_tibble(count(df_seg_critical, vars=segResp))
#tb_critical
# Further subset filler data set to those that were responded to by participants
df_seg_critical_wrong <- subset(df_seg_critical, df_seg_critical$segResp == 'None')

# Create a tibble of participants who incorrectly responded to a filler item
seg_critical_errors <- count(df_seg_critical_wrong,vars=partNum)
print('Counts of responses to filler items by participant')
print(as_tibble(seg_critical_errors),n=75) # n default is 10, but here it has been changed to 75 viewable rows

# Create a subset of all filler items
df_seg_filler <- subset(segData,segData$fillerCarrier %ni% c('carrierItem','targetSyl'))
print('Counts of responses to filler items \n1 = response \nNone = no response')
count(df_seg_filler, vars=segResp)
# Further subset filler data set to those that were responded to by participants
df_seg_filler_wrong <- subset(df_seg_filler, df_seg_filler$segResp == 1)
#print('Counts of responses to filler items by participant')
#count(df_seg_filler_wrong,vars=partNum)

# Create a tibble of participants who incorrectly responded to a filler item
seg_filler_errors <- count(df_seg_filler_wrong,vars=partNum)
print('Counts of responses to filler items by participant')
print(as_tibble(seg_filler_errors),n=75) # n default is 10, but here it has been changed to 75 viewable rows

# Find all participants who responded 43 or more times (>=10%) to filler items, will be used to index later
investigate <- c(which(seg_filler_errors$n > 43))
investigate

# Create new subset based only on participants who committed a high number errors to fillers
highSegErrors <- seg_filler_errors[investigate,] # creates tibble of participants and number of errors
highSegErrors

# Creates subset of wrong answers committed by high error rate participants
highSegErrorsPart <- df_seg_filler_wrong[df_seg_filler_wrong$partNum %in% highSegErrors$vars,]
highSegErrorsPart

# Creates subset of wrong answers commited by low error rate participants
lowSegErrorsPart <- df_seg_filler_wrong[df_seg_filler_wrong$partNum %ni% highSegErrors$vars,]
lowSegErrorsPart

# looks for too quick of response, anything below 200 ms
buttonHeld <- c(which(highSegErrorsPart$segRespRT < .200))
print('prints responses given below 200ms')
buttonHeld
techError <- highSegErrorsPart[buttonHeld,7:6]
print('prints responses given below 200ms by participant number')
techError
length(techError$segRespRT)

buttonNotHeld <- c(which(highSegErrorsPart$segRespRT > .200))
length(buttonNotHeld)

# Combine tibbles into new tibble
tb_tech_part_error <- full_join(count(techError,vars=partNum), count(highSegErrorsPart,vars=partNum), by = 'vars', copy = FALSE, suffix = c("_tech_errors", "_total_errors"))

# Add a column to new tibble with difference calculated to see real number of errors
tb_tech_error_removed <- add_column(tb_tech_part_error,non_technical_errors=tb_tech_part_error$n_total_errors - tb_tech_part_error$n_tech_errors,.after = 'n_total_errors')

# Test to see if any participant has still committed more than 10% error rate to filler items
re_investigate <- c(which(tb_tech_error_removed$non_technical_errors > 43))

# get numbers of each type of item
num_critical_items <- length(unique(segData$partNum)) * 48 # number of participants \* 48 trial blocks \* 1 critical item per trial block
num_filler_items <- length(unique(segData$partNum)) * 48 * 9 # number of participants \* 48 trial blocks \* 9 filler items per trial block
num_total_item <- num_critical_items + num_filler_items

if(num_total_item==length(segData$fillerCarrier)){
  print('counts looks good: total counts match ')
} else {
  print('some counts are off, recheck data')
}