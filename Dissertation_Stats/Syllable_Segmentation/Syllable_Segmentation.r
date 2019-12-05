#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(plyr)
library(readr)
library(tidyverse)

# Create 'not in' function
'%ni%' <- Negate('%in%')

# Create new vectors to use in transformations
row_to_column <- function(iterator_size, input_vector){
i <- 1 # r indexing start at 1, not 0
j <- iterator_size # how many rows need to be created

# for every item in the input vector, create specified number of rows needed to match length
for(item in input_vector){
  if(i==1){
    out_vector <- sprintf(item,i:j) # creates vector on first run
  } else {
    out_vector <- append(out_vector, sprintf(item,i:j)) # appends to vector on subsequent runs
  }
  i <- i + iterator_size
  j <- j + iterator_size
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

for(csv_file in segPaths){
  filename <- basename(csv_file)
  # Trial run on one participant
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

# clean up items no longer needed from environment
#rm(mod_part, target_column,targets, blocks, target_syllable_column, block_column, word_column, csv_file, filename, segDir, writeDir, segPaths, participant)

# This block requires 'plyr' and 'readr'
# Segmentation Data Directory
segDir <- transformed_directory #set path to directory
segFiles <- list.files(path=segDir, pattern = '*.csv', full.names = TRUE) #list all the files with path

# read in all the files into one data frame
segData = ldply(segFiles, read_csv)

# import multiple csv code modified from code posted at this link below https://datascienceplus.com/how-to-import-multiple-csv-files-simultaneously-in-r-and-create-a-data-frame/

# clean up unnecessary items in environment
# rm(segDir,segFiles)
# Need library 'tidyverse' loaded

# Create subset of all critical items
df_seg_critical <- subset(segData,segData$fillerCarrier == 'carrierItem')
count(df_seg_critical, vars=segResp)

# Create a subset of all filler items
df_seg_filler <- subset(segData,segData$fillerCarrier %ni% c('carrierItem','targetSyl'))
count(df_seg_filler, vars=segResp)

# Further subset filler data set to those that were responded to by participants
df_seg_filler_wrong <- subset(df_seg_filler, df_seg_filler$segResp == 1)
count(df_seg_filler_wrong,vars=partNum)

# Create a tibble of participants who incorrectly responded to a filler item
segErrors <- count(df_seg_filler_wrong,vars=partNum)
print(as_tibble(segErrors),n=50) # n default is 10, but here it has been changed to 50 viewable rows

# Find all participants who responded 43 or more times to filler items, will be used to index later
investigate <- c(which(segErrors$n > 43))

# Create new subset based only on participants who committed a high number errors to fillers
highSegErrors <- segErrors[investigate,] # creates tibble of participants and number of errors

# Creates subset of wrong answers committed by high error rate participants
highSegErrorsPart <- df_seg_filler_wrong[df_seg_filler_wrong$partNum %in% highSegErrors$vars,]

# Creates subset of wrong answers commited by low error rate participants
lowSegErrorsPart <- df_seg_filler_wrong[df_seg_filler_wrong$partNum %ni% highSegErrors$vars,]

# looks for too quick of response, anything below 200 ms
buttonHeld <- c(which(highSegErrorsPart$segRespRT < .200))
techError <- highSegErrorsPart[buttonHeld,7:6]

# Combine tibbles into new tibble
combine_tibble <- full_join(count(techError,vars=partNum), count(highSegErrorsPart,vars=partNum), by = 'vars', copy = FALSE, suffix = c(".x", ".y"),)

# Add a column to new tibble with difference calculated to see real number of errors
combine_tibble <- add_column(combine_tibble,difference=combine_tibble$n.y - combine_tibble$n.x,.after = 'n.y')

# Test to see if any participant has still committed more than 10% error rate to filler items
re_investigate <- c(which(combine_tibble$difference > 43))

# get numbers of each type of item
num_critical_items <- length(unique(segData$partNum)) * 48 # number of participants \* 48 trial blocks \* 1 critical item per trial block
num_filler_items <- length(unique(segData$partNum)) * 48 * 9 # number of participants \* 48 trial blocks \* 9 filler items per trial block
