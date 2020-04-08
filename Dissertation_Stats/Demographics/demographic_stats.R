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

# LexTALE-English Data Directory
lex_eng_dir = 'analyze_data/lexEngCols' #set path to directory
lex_eng_files = list.files(path=lex_eng_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path
#print(engFiles)

# read in all the files into one data frame
lex_eng_data = ldply(lex_eng_files, read_csv)

# LexTALE-Spanish Data Directory
lex_esp_dir = 'analyze_data/lexEspCols' #set path to directory
lex_esp_files = list.files(path=lex_esp_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path

# read in all the files into one data frame
lex_esp_data = ldply(lex_esp_files, read_csv)

# Basic Langauge Profile Data Directory
blp_dir = 'analyze_data/blpCols' #set path to directory
blp_files = list.files(path=blp_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path

# read in all the files into one data frame
blp_data = ldply(blp_files, read_csv)

# remove unnecessary values from Rstudio Environment
rm(blp_dir, blp_files, lex_eng_dir, lex_eng_files, lex_esp_dir, lex_esp_files)

# rename column headers
names(blp_data)[names(blp_data)=='sectionEng'] <- 'blp_section'
names(blp_data)[names(blp_data)=='questionTextEng'] <- 'blp_question'
names(blp_data)[names(blp_data)=='languageEng'] <- 'question_language'
names(blp_data)[names(blp_data)=='langHistResp3'] <- 'langHistResp'
names(blp_data)[names(blp_data)=='langHistRT3'] <- 'langHistRT'
# names(blp_data)

# create one column for Language History responses
i <- 1
j <- 2

while (i<length(blp_data$blp_question))
{
  blp_data$langHistResp[i:j] <- blp_data$langHistResp1[i:j] # copies information from langHistResp1 to langHistResp
  blp_data$langHistRT[i:j] <- blp_data$langHistRT1[i:j] # copies information from langHistRT1 to langHistRT
  i <- i + 2
  j <- j + 2
  blp_data$langHistResp[i:j] <- blp_data$langHistResp2[i:j] # copies information from langHistResp2 to langHistResp
  blp_data$langHistRT[i:j] <- blp_data$langHistRT2[i:j] # copies information from langHistRT2 to langHistRT
  i <- i + 41
  j <- j + 41
}

# deletes unnecessary columns
blp_data_cleaned <- select(blp_data, -c(Order, color, langHistResp1, langHistRT1, langHistResp2, langHistRT2))

# deletes practice rows in LexTALE test
lex_eng_cleaned <- subset(lex_eng_data, lex_eng_data$Order !=0)
lex_esp_cleaned <- subset(lex_esp_data, lex_esp_data$Order !=0)

# create dataframe for each blp section
lang_history <- subset(blp_data_cleaned, blp_section == 'Language history')
lang_history_clean <- select(lang_history, -c(langUseResp,langUseRT,langProfResp,langProfRT,langAttResp, langAttRT))
lang_use <- subset(blp_data_cleaned, blp_section == 'Language use')
lang_use_clean <- select(lang_use, -c(langHistResp,langHistRT,langProfResp,langProfRT,langAttResp, langAttRT))
lang_proficiency <- subset(blp_data_cleaned, blp_section == 'Language proficiency')
lang_proficiency_clean <- select(lang_proficiency, -c(langHistResp,langHistRT,langUseResp,langUseRT,langAttResp, langAttRT))
lang_attitude <- subset(blp_data_cleaned, blp_section == 'Language attitudes')
lang_attitude_clean <- select(lang_attitude, -c(langHistResp,langHistRT,langUseResp,langUseRT,langProfResp,langProfRT))

# remove raw files imported in Rstudio environment
rm(blp_data, lex_eng_data, lex_esp_data,i,j,lang_history,lang_use,lang_proficiency,lang_attitude)

# get LexTALE scores
lex_eng_score <- aggregate(data=lex_eng_cleaned, lexRespEngCorr ~ partNum + birthCountry, FUN='mean')
lex_esp_score <- aggregate(data=lex_esp_cleaned, lexRespEspCorr ~ partNum + birthCountry, FUN='mean')

# create blp score tables
blp_history_score <- aggregate(data=lang_history_clean, langHistResp ~ partNum + question_language, FUN='sum')
blp_use_score <- aggregate(data=lang_use_clean, langUseResp ~ partNum + question_language, FUN='sum')
blp_proficiency_score <- aggregate(data=lang_proficiency_clean, langProfResp ~ partNum + question_language, FUN='sum')
blp_attitude_score <- aggregate(data=lang_attitude_clean, langAttResp ~ partNum + question_language, FUN='sum')

# Global Language Scores
english <- all[blp_history_score$question_language == 'English',]
