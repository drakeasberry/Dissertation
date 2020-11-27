#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(plyr)
library(readr)
library(tidyverse)
library(tidyr)
library(lattice)
library(ggplot2)

# Create 'not in' function
'%ni%' <- Negate('%in%')

# Surpress all readr messages by default
# https://www.reddit.com/r/rstats/comments/739vf6/how_to_turn_off_readrs_messages_by_default/
options(readr.num_columns = 0)

# Load all files 
# list all the files with path
seg_files <- list.files(path='analyze_data/raw', pattern = '*.csv', full.names = TRUE) 

# read in all the files into one data frame
# import multiple csv code modified from code posted at this link below:
#https://datascienceplus.com/how-to-import-multiple-csv-files-simultaneously-in-r-and-create-a-data-frame/
df_raw_seg <- ldply(seg_files, read_csv)

# Delete practice trial rows
exper_trials <- drop_na(df_raw_seg, any_of("corrAns"))

# Read file containing information that connects participant number to group affiliation
group_map <- read_csv('../../Scripts_Dissertation/participant_group_map.csv')

# Create complete dataset of all participants and their results for Segmenation Experiment 
segmentation_data <- exper_trials %>% 
  # add group map information
  left_join(group_map, by = 'partNum') %>%
  # create millisecond RT and log RT columns
  mutate(segRespRTmsec = round(segRespRT * 1000),
         log_RT = log(segRespRTmsec)) %>% 
  rename(segRespRTsec = segRespRT, 
         word = expWord, 
         word_status = wd_status,
         word_initial_syl = wd_int_syl_str, 
         target_syl_structure = tar_syl_str,
         targetSyl = tar_syl, 
         exp_word_type = fillerCarrier) %>% 
  select("partNum", "group", "segResp", "segRespCorr", "segRespRTsec", "segRespRTmsec", "log_RT", "lemma",
         "word", "word_status", "word_initial_syl", "targetSyl", "target_syl_structure", "matching", 
         "exp_word_type", "block")

#---
# These items are only used in the Rstudio environment
# Clean up unnecessary items in environment
rm(df_raw_seg, exper_trials, group_map, seg_files)
#---

# Create subset of all critical items
seg_critical <- segmentation_data %>% 
  subset(., exp_word_type == 'critical') 

# Prints tibble showing all responses and frequency of response to critical items
print('Counts of responses to critical items')
print('1 = response and 0 = no response')
count(seg_critical, vars=segRespCorr) %>% 
  rename(Response = vars, Count = n)

# Run initial pass according to previous literature
seg_critical_correct <- seg_critical %>% 
  subset(., segResp == 'b') %>% # remove all missed critical items n=246
  subset(., segRespRTmsec > 200) %>% # remove response times less than 200ms n=4
  subset(., segRespRTmsec < 1500) %>% # remove response times greater than 1500ms n=154
  select(-c('exp_word_type', 'segResp')) # remove columns

# Check to ensure no column only contains one unique value
seg_critical_correct %>% 
  summarise_all(n_distinct)

# Check minimum and maximum reaction times 
seg_critical_correct %>% 
  summarise_at(vars(segRespRTmsec),list(quickest = min, slowest = max))

# Further subset critical data set to those that were NOT responded to by participants
seg_critical_misses <- subset(seg_critical, seg_critical$segRespCorr == 0)

# Create a table of critical miss counts by participants
print('Counts of responses to critical items by participant')
df_seg_critical_errors <- count(seg_critical_misses, vars=partNum) %>% 
  rename(Participant = vars, Critical_Misses = n) %>% 
  print()

# Find users with greater than 10% error rate
high_miss_seg_critical_responses <- subset(df_seg_critical_errors, 
                                           df_seg_critical_errors$Critical_Misses >= 6.4) %>% 
  rename(partNum = Participant) %>% # rename for ease in following scripts
  print()

# Write output file for use in Demographic analysis
write_csv(high_miss_seg_critical_responses, '../Demographics/analyze_data/from_exp_analysis/online_learners_segmentation_high_error_rates.csv')


# Create a subset of all filler items
seg_filler <- segmentation_data %>% 
  subset(., exp_word_type != 'critical')
print('Counts of responses to filler items')
print('0 = response and 1 = no response')
# Prints tibble showing all responses and frequency of response to filler items
count(seg_filler, vars=segRespCorr) %>% 
  rename(Response = vars, Count = n)

# Further subset filler data set to those that were responded to by participants
seg_filler_responses <- subset(seg_filler, seg_filler$segRespCorr == 0)

# Create a dataframe of participants who incorrectly responded to a filler item
print('Counts of responses to filler items by participant')
df_seg_filler_errors <- count(seg_filler_responses, vars=partNum) %>% 
  rename(Participant = vars, Count = n) %>% 
  print()

# Find all participants who responded 57 or more times (>=10%) to filler items
high_seg_filler_responses <- subset(df_seg_filler_errors, df_seg_filler_errors$Count >= 57.6) %>%
  rename(Filler_Errors = Count) %>% 
  print()

if(length(high_seg_filler_responses$Participant)==0){
  high_seg_filler_responses = seg_filler_responses
  # Create table of errors committed by low error participants
  high_filler_part_raw <- subset(seg_filler_responses, 
                                 seg_filler_responses$partNum %ni% high_seg_filler_responses$Participant)
} else{
  high_seg_filler_responses = high_seg_filler_responses
  # Create table of errors committed by high error participants
  high_filler_part_raw <- subset(seg_filler_responses, 
                                 seg_filler_responses$partNum %in% high_seg_filler_responses$Participant)
}



# Looks for too quick of response, anything below 200 ms caused by button being held from previous trial
button_held_high <- subset(high_filler_part_raw, high_filler_part_raw$segRespRT < .200) %>% 
  select('partNum','segRespRTsec') #n=218

# Not technical issue filler errors by high error rate participants
button_not_held_high <- subset(high_filler_part_raw, high_filler_part_raw$segRespRT >= .200) #n=81

# Number of errors committed by participant after correction for technical limitations
high_filler_part_corrected <- count(button_not_held_high, vars = partNum) %>% 
  rename(Participant = vars, Corrected_Filler_Errors = n) %>% 
  print()

# Test to see if any participant has still committed more than 10% error rate to filler items
# If investigate has participants, they need to be removed for higher error rates,
# If investigate is empty, this is a positive.
investigate <- subset(high_filler_part_corrected,
                      high_filler_part_corrected$Corrected_Filler_Errors > 43)

if(length(investigate$Participant) == 0){
  segmentation <- subset(seg_critical_correct, seg_critical_correct$partNum %ni% 
                           high_miss_seg_critical_responses$partNum)
  print('No issues here...')
  print('Output file being created...removing high critical error rate pariticipants.')
  print(sprintf('%d participants removed from data leaving %d participants remaining', 
                length(high_miss_seg_critical_responses$partNum), length(unique(segmentation$partNum))))
  print(sprintf('%s was removed', unique(high_miss_seg_critical_responses$partNum)))
  print(sprintf('%s is eligible', unique(segmentation$partNum)))
  # Write statement for file containing only necessary columns for segmentation analysis
  write_csv(segmentation, 'analyze_data/output/55_online_learners_segmentation.csv')
  # For PI Advisor
  #write_csv(segmentation, 'analyze_data/output/data.csv')
  segmentation %>% 
    select('partNum') %>% 
    unique() %>% 
    write_csv(., '../Demographics/analyze_data/from_exp_analysis/55_eligible_online_learners_part.csv')
  rm(button_held_high, button_not_held_high, high_miss_seg_critical_responses, 
     high_seg_filler_responses, df_seg_critical_errors, df_seg_filler_errors, investigate,
     high_filler_part_raw, high_filler_part_corrected, seg_critical, seg_critical_misses,
     seg_filler, seg_filler_responses, seg_critical_correct)
} else{
  print('See who has too many errors:')
  print(investigate$Participant)
}


# Consider creating new file here for visualization