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
      # appends to vector on subsequent runs
      out_vector <- append(out_vector, as.character(carriers[[item]])) 
    }
    i <- i + iterator_size
    j <- j + iterator_size
  }
  return(out_vector)
}


# get all csv files from directory
seg_dir = 'analyze_data/raw' #set path to directory
seg_paths = list.files(path=seg_dir, pattern = '*.csv', full.names = TRUE) # list all the files with path

# transforms data structure for use in analysis
for(csv_file in seg_paths){
  filename <- basename(csv_file)
  # Each trial loop runs one participant
  df_participant_raw <- read_csv(csv_file) # reads in raw data file from analyze_data directory

  # Create subset to build vectors for transformation
  # includes only trial columns (48)
  df_participant_modified <- as_tibble(select(df_participant_raw, block01:block48))
  
  # subset dataframe to get 'targetSyl' row only once
  df_target_column <- filter(df_participant_modified, row_number() == 11L)
  
  # create vectors to transform syllable targets and block trial numbers
  targets <- as.character(df_target_column) # creates vector of all targets
  blocks <- as.character(colnames(df_participant_modified)) # creates a vector of all block labels
  
  # Call function to expand vectors to match dataframe length
  # converts target vector column with appropriate length
  target_syllable_column <- do.call('row_to_column',list(11,targets))
  # converts block label vector column with appropriate length
  block_column <- do.call('row_to_column',list(11,blocks))
  # grabs all words and puts them into one column
  word_column <- do.call('words_to_column',list(df_participant_raw, 11, blocks))
  
  # Create new dataframe with three new transformed columns
  df_participant_transformed <- add_column(df_participant_raw, targetSyl= target_syllable_column, 
                                           block= block_column, word= word_column)
  
  # subset to keep only columns necessary
  df_participant_transformed_correct_columns <- select(df_participant_transformed, fillerCarrier, 
                                                       block, word, targetSyl, segResp, segRespRT, 
                                                       partNum, session, age, gender, birthCountry,
                                                       placeResidence, education, preferLanguage, 
                                                       date, expName)

  # Further subset to drop target syllable rows (48 in total)
  df_participant_clean <- filter(df_participant_transformed_correct_columns, fillerCarrier != 'targetSyl')

  # write transformed tibble to csv file
  # create new path to transformed directory name for updated files
  transformed_dir <- file.path(seg_dir, '../transformed/') 
  # write out corrected file to new directory
  write_csv(df_participant_clean, file.path(transformed_dir, filename))
}


# Segmentation Data Directory
# list all the files with path
seg_files <- list.files(path='analyze_data/transformed/', pattern = '*.csv', full.names = TRUE) 

# read in all the files into one data frame
# import multiple csv code modified from code posted at this link below:
#https://datascienceplus.com/how-to-import-multiple-csv-files-simultaneously-in-r-and-create-a-data-frame/
df_raw_seg <- ldply(seg_files, read_csv)

#---
# These items are only used in the Rstudio environment
# Clean up unnecessary items in environment
rm(df_participant_clean, df_participant_transformed_correct_columns,
   df_participant_transformed, df_participant_raw,df_participant_modified,
   df_target_column, targets, blocks, target_syllable_column, block_column,
   word_column, csv_file, filename, seg_dir, seg_paths, seg_files, transformed_dir)
#---

# Create a new dataframe to join to participant data needed for analysis
# Get all condition csv files copied from processed experiment directory
join_dir = 'analyze_data' #set path to directory
# list all the files with path
join_paths = list.files(path=join_dir, pattern = '*[ABCD].csv', full.names = TRUE)

# Each trial loop runs one condition A,B,C or D
for(csv_condition in join_paths){
  # get filename without path
  filename <- basename(csv_condition)
  # select the 8th character which equals experimental condition
  cond <- str_sub(filename,8,8)
  # reads in raw data file from analyze_data directory
  df_raw_cond <- read_csv(csv_condition, col_names = FALSE)
  df_items <- df_raw_cond[-c(1, 2, 3),] #remove first three rows

  # Iterates through block, real/nonreal and target syllable columns to be created
  i <- 1
  while (i <= 3) {
    row <- paste('row',i, sep='_')
    row_tran <- paste('row_tran',i, sep='_')
    col = filter(df_raw_cond, row_number() == i)
    # take 10 rows for columns 3 through 50 
    assign(row_tran, row_to_column(10,col[3:50]))
    i = i + 1
  }

  # Populates data for block, word status and target syllable columns
  j <- 2 # start at 2 to avoid repition of column names as data
  col_labels <- df_items[,2]
  names(col_labels) <- 'fillerCarrier' # rename column meaningfully

  # Iterate through each column needing transformation (48 in total)
  while (j <= length(df_items)) {
    exp_words <- df_items[,j]
    names(exp_words) <- 'word' # rename column meangingfully

    if (j == 2){
      # stores fillerCarrier and condition column
      out_tibble <- col_labels 
    } else if (j==3) {
      # add experimental words column
      out_tibble = bind_cols(out_tibble, exp_words)
    } else {
      # stores current experimental words selected
      temp_tibble = bind_cols(col_labels, exp_words)
      # adds current word selection to existing table
      out_tibble <- rbind(out_tibble, temp_tibble)
    }
    # creates new vector transformed for 3 columns needed for each final condition file
    df_cond_tran <- paste(row_tran,filename,sep = '_')
    j = j + 1
  }
  # Build table with transformed columns
  assign(df_cond_tran, tibble(block = row_tran_1, word_status = row_tran_2, target_syl = row_tran_3))
  # add column to label condition
  out_tibble <- add_column(out_tibble, condition = cond)
  # Creates table for each condition file A, B, C, D separately
  assign(filename, out_tibble)
}

# Combine all 4 condition files into a single table
all_conditions <- rbind(expCondA.csv, expCondB.csv, expCondC.csv, expCondD.csv)
# Create single table with all 4 condiitons with the 3 transformed columns
all_data_tranformations <- rbind(row_tran_3_expCondA.csv,row_tran_3_expCondB.csv,
                                 row_tran_3_expCondC.csv,row_tran_3_expCondD.csv)
# Combine condition table columns with transformation table
exp_joiner <- all_data_tranformations %>% 
  bind_cols(all_conditions) %>%
  # Replace values to indicate word versus nonword
  mutate(word_status = ifelse(grepl('Real[0-9]+',word_status),'word','nonword'))

#---
# These items are only used in the Rstudio environment
# Clean up unnecessary items in environment
rm(all_conditions, all_data_tranformations, col, df_cond_tran, df_raw_cond, df_items, 
   exp_words, expCondA.csv, expCondB.csv, expCondC.csv, expCondD.csv, col_labels, 
   out_tibble, row_tran_3_expCondA.csv, row_tran_3_expCondB.csv, row_tran_3_expCondC.csv, 
   row_tran_3_expCondD.csv, temp_tibble, csv_condition, filename, i, j, row, row_tran, 
   row_tran_1, row_tran_2, row_tran_3, cond, join_dir, join_paths, row_to_column,
   words_to_column)
#---

# Read in experiment files contatining information about experimental items needed
# for analysis and will be joined to participant data
keep_columns <- c('word','word_initial_syl','word_freq') # keep only these columns

# Build critical items table
exp_error <- tibble(word='permsio',word_initial_syl='CVC') # typo in experimental item added to list
# Read critical items file generated from original experiment Excel workbook
df_critical <- read_csv('analyze_data/Critical_Items.csv')

# Remove unnecessary information
df_critical <- df_critical %>%
  # Remove practice trials
  subset(Exp_Prac=='Experimental') %>%
  # Remove irrelevant columns
  select(keep_columns)


# Bind error row and experimental items
df_critical <- rbind.fill(df_critical, exp_error)

# Read filler item files generated from original experiment Excel workbook
df_rw_filler <- read_csv('analyze_data/RW_Filler_Items.csv')
df_pw_filler <- read_csv('analyze_data/PW_Filler_Items.csv')

# combine pseudo/real word tiblles and drop unnecessary columns
df_filler <- rbind.fill(df_rw_filler, df_pw_filler) %>%
  select(keep_columns)

# Combine potential fillers and actual critical items into a single tibble
corpus_joiner <- rbind(df_critical, df_filler)

# Join experimenatl condition with potentials from critical/filler joins
complete_joiner <- exp_joiner %>%
  # join experiment condition files with corpus information
  inner_join(corpus_joiner, by = 'word') %>%
  # remove duplicate rows
  distinct() %>%
  # Remove unnecessary columns
  select(keep_columns,'word_status')


# Join word freq table with experimental results from participants
seg_data_join <- df_raw_seg %>%
  # join participant data
  inner_join(complete_joiner, by = 'word') %>%
  distinct() %>% # remove duplicates
  # add columns for type of experimental word, target syllable structure and matching condition
  mutate(exp_word_type = ifelse(fillerCarrier =='carrierItem','carrier','filler'),
         target_syl_structure = ifelse(str_length(targetSyl)==2,'CV','CVC'),
         matching = ifelse(word_initial_syl == target_syl_structure,'matching','mismatching')) %>%
  # removed data point with typo from 6 Eng and 7 Esp participants
  subset(., word != 'permsio') %>%
  # select columns to keep
  select(c("partNum","segResp":"segRespRT","word","word_status","word_initial_syl","word_freq",
           "targetSyl", "target_syl_structure","matching", "exp_word_type","expName","block",
           "session":"date"))

#---
# These items are only used in the Rstudio environment
# Clean up unnecessary items in environment
rm(df_critical, df_rw_filler, df_pw_filler, exp_error, complete_joiner, corpus_joiner,
   df_filler, exp_joiner, df_raw_seg, keep_columns)
#---

# Read file containing information that connects participant number to group affiliation
group_map <- read_csv('../../Scripts_Dissertation/participant_group_map.csv')

# Create complete dataset of all participants and their results for Segmenation Experiment 
segmentation_data <- seg_data_join %>% 
  # add group map information
  left_join(group_map, by = 'partNum') %>%
  # create millisecond RT and log RT columns
  mutate(segRespRTmsec = round(segRespRT * 1000),
         log_RT = log(segRespRTmsec)) %>% 
  # rename to label seconds in original RT column
  rename(segRespRTsec = segRespRT) %>% 
  # rearrange and keep only necessary columns for analysis
  select(c("partNum", "group", "segResp","segRespRTsec", "segRespRTmsec", "log_RT", 
           "word":"exp_word_type", "block"))

# Remove all participants from heritage group
segmentation_data_no_heritage <- subset(segmentation_data, segmentation_data$group != "Childhood")

# Create subset of all critical items
seg_critical <- subset(segmentation_data_no_heritage, segmentation_data_no_heritage$exp_word_type == 'carrier')

# Prints tibble showing all responses and frequency of response to critical items
print('Counts of responses to critical items')
print('1 = response and None = no response')
count(seg_critical, vars=segResp) %>% 
  rename(Response = vars, Count = n)

# Number of responses over 1500ms by participant
seg_critical %>% 
  subset(., segResp == 1) %>%
  subset(., segRespRTmsec > 1500) %>%
  View()
  count(., vars = partNum)

# Number of responses under 200ms by participant
seg_critical %>% 
  subset(., segResp == 1) %>%
  subset(., segRespRTmsec < 200) %>% 
  count(., vars = partNum)

# Run initial pass according to previous literature
seg_critical_correct <- seg_critical %>% 
  subset(., segResp == 1) %>% # remove all missed critical items n=28
  subset(., segRespRTmsec >= 200) %>% # remove response times less than 200ms n=27
  subset(., segRespRTmsec <= 1500) %>% # remove response times greater than 1500ms n=11
  select(-c('exp_word_type', 'segResp')) # remove columns

# Check to ensure no column only contains one unique value
seg_critical_correct %>% 
  summarise_all(n_distinct)

# Check minimum and maximum reaction times 
seg_critical_correct %>% 
  summarise_at(vars(segRespRTmsec),list(quickest = min, slowest = max))

#---
# These items are only used in the Rstudio environment
# Clean up unnecessary items in environment
rm(group_map, segmentation_data)
#---

# Further subset critical data set to those that were NOT responded to by participants
seg_critical_misses <- subset(seg_critical, seg_critical$segResp == 'None')

# Create a table of critical miss counts by participants
print('Counts of responses to critical items by participant')
df_seg_critical_errors <- count(seg_critical_misses, vars=partNum) %>% 
  rename(Participant = vars, Critical_Misses = n) %>% 
  print()

# Find users with greater than 10% error rate
high_miss_seg_critical_responses <- subset(df_seg_critical_errors, 
                                           df_seg_critical_errors$Critical_Misses >= 4.8) %>% 
  rename(partNum = Participant) %>% # rename for ease in following scripts
  print()

# Write output file for use in Demographic analysis
write_csv(high_miss_seg_critical_responses, 
          '../Demographics/analyze_data/output/lab_segmentation_high_error_rates.csv')


# Create a subset of all filler items
seg_filler <- subset(seg_data_join, seg_data_join$exp_word_type != 'carrier')
print('Counts of responses to filler items')
print('1 = response and None = no response')
# Prints tibble showing all responses and frequency of response to filler items
count(seg_filler, vars=segResp) %>% 
  rename(Response = vars, Count = n)

# Further subset filler data set to those that were responded to by participants
seg_filler_responses <- subset(seg_filler, seg_filler$segResp == 1)

# Create a dataframe of participants who incorrectly responded to a filler item
print('Counts of responses to filler items by participant')
df_seg_filler_errors <- count(seg_filler_responses, vars=partNum) %>% 
  rename(Participant = vars, Count = n) %>% 
  print()

# Find all participants who responded 43 or more times (>=10%) to filler items
high_seg_filler_responses <- subset(df_seg_filler_errors, df_seg_filler_errors$Count >= 43.2) %>%
  rename(Filler_Errors = Count) %>% 
  print()

# Create table of errors committed by high error participants
high_filler_part_raw <- subset(seg_filler_responses, 
                               seg_filler_responses$partNum %in% high_seg_filler_responses$Participant)

# Looks for too quick of response, anything below 200 ms caused by button being held from previous trial
button_held_high <- subset(high_filler_part_raw, high_filler_part_raw$segRespRT < .200) %>% 
  select('partNum','segRespRT') #n=218

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
  write_csv(segmentation, 'analyze_data/output/45_lab_segmentation.csv')
  # For PI Advisor
  #write_csv(segmentation, 'analyze_data/output/data.csv')
  segmentation %>% 
    select('partNum') %>% 
    unique() %>% 
    write_csv(., '../Demographics/analyze_data/45_eligible_lab_part.csv')
  rm(button_held_high, button_not_held_high, high_miss_seg_critical_responses, 
     high_seg_filler_responses, df_seg_critical_errors, df_seg_filler_errors, investigate,
     high_filler_part_raw, high_filler_part_corrected, seg_critical, seg_critical_misses,
     seg_data_join, seg_filler, seg_filler_responses, segmentation_data_no_heritage, 
     seg_critical_correct)
  } else{
    print('See who has too many errors:')
    print(investigate$Participant)
  }
