#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(plyr)
library(readr)
library(tidyverse)
library(ggplot2)
library(kableExtra)
library(qwraps2)
library(jmv)
library(stargazer)

# Create and store functions 
# create 'not in' function
'%ni%' <- Negate('%in%')
# create logit tranformation function
logitTrans <- function(x) { log(x/(1-x)) }

# Surpress all readr messages by default
# https://www.reddit.com/r/rstats/comments/739vf6/how_to_turn_off_readrs_messages_by_default/
options(readr.num_columns = 0)

options(qwraps2_markup = "latex")

# Load dataframe containing participant number and group affiliation 
group_map <- read_csv('../../Scripts_Dissertation/participant_group_map.csv')

# Get all csv files from directory
# Set file directory path
syllable_dir <- 'analyze_data/raw' 
# Create vector of all files with path
syllable_files <- list.files(path=syllable_dir, pattern = '*.csv', full.names = TRUE)

# Read all csv files into a single dataframe
syllable_data_raw <- ldply(syllable_files, read_csv)

# Prepare raw data for anaylsis
# Create new dataframe based off raw input dataframe
syllable_data <- syllable_data_raw %>%
  left_join(group_map, by = 'partNum') %>% # add group as dataframe column
  # combine experiment words into signle column
  mutate(word = ifelse(is.na(word) == TRUE, syllabification, word),
         sylRespRTmsec = round(sylRespRT * 1000), # create new column with RT in (ms)
         # create new column containing syllable structure
         syl_structure = ifelse(str_length(corrSyl) == 2, 'CV', 'CVC')) %>%
  rename(sylRespRTsec = sylRespRT) %>% #rename old column to sylRespRTsec
  # dropped 4 no response items from part065 and 1 from part072
  drop_na("sylRespRTsec") %>%
  # select columns to keep in dataframe
  select("partNum", "group", "sylRespCorr", "sylRespRTsec", "sylRespRTmsec", "syl_structure",
         "corrSyl", "word")

# Remove unnecessary elements from R environment
rm(group_map, syllable_data_raw, syllable_dir, syllable_files)

# Check reaction times for range
syllable_data %>%
  summarise_at(vars(sylRespRTmsec), list(fastest = min, slowest = max)) 

# Check to make sure no single value columns exist
syllable_data %>%
  summarise_all(n_distinct)

# Remove Heritage speaker group
# remove heritage participants in group "Childhood"
syllable_data_no_heritage <- subset(syllable_data, syllable_data$group != "Childhood")

# Check to make sure no single value columns exist
syllable_data_no_heritage %>%
  summarise_all(n_distinct)

# Remove unnecessary elements from R environment
rm(syllable_data)

# Write statement for file containing only necessary columns for intuition analysis
write_csv(syllable_data_no_heritage, 'analyze_data/output/esp_eng_67_intuition.csv')
# For PI Advisor naming convention in secure cloud storage
write_csv(syllable_data_no_heritage, 'analyze_data/output/data.csv') 

# Jomovi Analysis Data Transformation 
# Create new long form dataframe with new columns needed for analysis
mydata_long <- syllable_data_no_heritage %>%
  # keep participant, group and syllable structure column for summary
  group_by(partNum, group, syl_structure) %>%
  # add new column with percent correct by participant and syllable structure
  summarise(correct = mean(sylRespCorr)) %>%
  # transform current data in correct column from 1 to 0.9999 for regression
  mutate(correct = ifelse(correct == 1, 0.9999, correct),
         # apply logit function to percent correct column and store in new column
         logit = logitTrans(correct))

# Write long form dataframe to csv
write_csv(mydata_long, 'analyze_data/output/data_long.csv')

## Create new wide form dataframe with new columns needed for analysis
#mydata_wide <- mydata_long %>%
#  # delete the percent correct column
#  select(-c(correct)) %>%
#  # transform syllable structure column into separate columns based on syllable structure
#  # keep the values from logit column and now should have only 1 row per participant
#  pivot_wider(names_from = syl_structure, values_from = logit)
#  
## Write wdie form dataframe to csv
#write_csv(mydata_wide, 'analyze_data/output/data_wide.csv')

# Remove unnecessary elements from R environment
#rm(syllable_data_no_heritage)

# Demographic Information Descriptions
# Load demographic data
demo_data <- read_csv('analyze_data/demographics/67_lab_intuition.csv')

# Box plots
# Language Dominance
ggplot(data = demo_data, 
       aes(x = group,
           y = lang_dominance)) +
  geom_boxplot(color = "purple", width = 0.5,
               outlier.shape = 8, outlier.size = 2) +
  geom_violin(color = "red", fill = NA) +
  geom_jitter(width = 0.1) +
  ggtitle("Language Dominance") +
  xlab("Native Language Group") +
  ylab("Basic Language Profile Dominance Score")
  
# English Vocabulary Size
ggplot(data = demo_data, 
       aes(x = group,
           y = lextale_eng_correct)) +
  geom_boxplot(color = "purple", width = 0.5,
               outlier.shape = 8, outlier.size = 2) +
  geom_violin(color = "red", fill = NA) +
  geom_jitter(width = 0.1) +
  ggtitle("English Vocabulary Size") +
  xlab("Native Language Group") +
  ylab("English Vocabulary % correct")

# Spanish Vocabulary Size
ggplot(data = demo_data, 
       aes(x = group,
           y = lextale_esp_correct)) +
  geom_boxplot(color = "purple", width = 0.5,
               outlier.shape = 8, outlier.size = 2) +
  geom_violin(color = "red", fill = NA) +
  geom_jitter(width = 0.1) +
  ggtitle("Spanish Vocabulary Size") +
  xlab("Native Language Group") +
  ylab("Spanish Vocabulary % correct")


#summary <- list("Language Dominance" = list("mean (sd)" = ~ qwraps2::mean_sd(lang_dominance)))
dominance_summary <-
  list("Language Dominance" =
         list(#"min"       = ~ min(lang_dominance),
              #"max"       = ~ max(lang_dominance),
              "mean (sd)" = ~ qwraps2::mean_sd(lang_dominance)),
       "English Vocabulary Size" =
         list(#"min"       = ~ min(lextale_eng_correct),
              #"median"    = ~ median(lextale_eng_correct),
              #"max"       = ~ max(lextale_eng_correct),
              "mean (sd)" = ~ qwraps2::mean_sd(lextale_eng_correct)),
       "Spanish Vocabulary Size" =
         list(#"min"       = ~ min(lextale_esp_correct),
              #"max"       = ~ max(lextale_esp_correct),
              "mean (sd)" = ~ qwraps2::mean_sd(lextale_esp_correct))
  )              

by_lang <- summary_table(dplyr::group_by(demo_data, group),dominance_summary)
print(by_lang)
 
by_lang %>% 
  kbl(caption = "Descriptives") %>%
  kable_styling() %>% 
  pack_rows("Language Dominance", 1, 1) %>% 
  pack_rows("English Vocabulary Size", 2, 2) %>%
  pack_rows("Spanish Vocabulary Size", 3, 3) %>%
  kable_classic(full_width = F, html_font = "Cambria")

#intuition_summary <-
#  list("CV" =
#         list(#"min"       = ~ min(CV),
#              #"max"       = ~ max(CV),
#              "mean (sd)" = ~ qwraps2::mean_sd(CV)),
#       "CVC" =
#         list(#"min"       = ~ min(CVC),
#              #"median"    = ~ median(CVC),
#              #"max"       = ~ max(CVC),
#              "mean (sd)" = ~ qwraps2::mean_sd(CVC)),
#       "Spanish Vocabulary Size" =
#         list(#"min"       = ~ min(lextale_esp_correct),
#              #"max"       = ~ max(lextale_esp_correct),
#              "mean (sd)" = ~ qwraps2::mean_sd(lextale_esp_correct))
#  ) 
#
##intuition <- mydata_long %>% 
##  summary_table(dplyr::group_by(intuition, group),intuition_summary)
##
#print(intuition)

#stargazer(,
#          title="Descriptive Statistics for Selected Study Variables", 
#          type = "text", #This helps your preview in non-latex output in #the console
#          summary = TRUE,
#          rownames = TRUE,
#          summary.stat = c("min", "max", "mean", "sd"),
#          notes = "Notes: n = 150.")
#