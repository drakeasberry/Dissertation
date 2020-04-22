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
lex_eng_dir = 'analyze_data/lextale_eng_cols' #set path to directory
lex_eng_files = list.files(path=lex_eng_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path
#print(engFiles)

# read in all the files into one data frame
lex_eng_data = ldply(lex_eng_files, read_csv)

# LexTALE-Spanish Data Directory
lex_esp_dir = 'analyze_data/lextale_esp_cols' #set path to directory
lex_esp_files = list.files(path=lex_esp_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path

# read in all the files into one data frame
lex_esp_data = ldply(lex_esp_files, read_csv)

# Basic Langauge Profile Data Directory
blp_dir = 'analyze_data/blp_cols' #set path to directory
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

# subset experimental and participant information 
demographics <- select(blp_data_cleaned, 'partNum':'expName')
demographics <- demographics[!duplicated(demographics$partNum),] # reduce to one row per participant

# deletes practice rows in LexTALE test
lex_eng_cleaned <- subset(lex_eng_data, lex_eng_data$Order !=0)
lex_esp_cleaned <- subset(lex_esp_data, lex_esp_data$Order !=0)

# get LexTALE scores
# commented lines only for quick viewing purposes, NOT analysis
#lex_eng_score <- aggregate(data=lex_eng_cleaned, lexRespEngCorr ~ partNum + birthCountry, FUN='mean')
#lex_esp_score <- aggregate(data=lex_esp_cleaned, lexRespEspCorr ~ partNum + birthCountry, FUN='mean')
lex_eng_score <- aggregate(data=lex_eng_cleaned, lextaleRespEngCorr ~ partNum, FUN='mean')
names(lex_eng_score)[names(lex_eng_score)=='lextaleRespEngCorr'] <- 'lextale_eng_correct'
lex_esp_score <- aggregate(data=lex_esp_cleaned, lextaleRespEspCorr ~ partNum, FUN='mean')
names(lex_esp_score)[names(lex_esp_score)=='lextaleRespEspCorr'] <- 'lextale_esp_correct'

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

# create blp score tables
blp_history_score <- aggregate(data=lang_history_clean, langHistResp ~ partNum + question_language, FUN='sum')
blp_use_score <- aggregate(data=lang_use_clean, langUseResp ~ partNum + question_language, FUN='sum')
blp_proficiency_score <- aggregate(data=lang_proficiency_clean, langProfResp ~ partNum + question_language, FUN='sum')
blp_attitude_score <- aggregate(data=lang_attitude_clean, langAttResp ~ partNum + question_language, FUN='sum')

# Global Language Scores
# English Scores
eng_hist <- blp_history_score[blp_history_score$question_language == 'English',]
names(eng_hist)[names(eng_hist)=='langHistResp'] <- 'eng_hist_score'
eng_hist <- select(eng_hist, -c(question_language))
eng_use <- blp_use_score[blp_use_score$question_language == 'English',]
names(eng_use)[names(eng_use)=='langUseResp'] <- 'eng_use_score'
eng_use <- select(eng_use, -c(question_language))
english <- merge(eng_hist,eng_use,by='partNum')
eng_prof <- blp_proficiency_score[blp_proficiency_score$question_language == 'English',]
names(eng_prof)[names(eng_prof)=='langProfResp'] <- 'eng_prof_score'
eng_prof <- select(eng_prof, -c(question_language))
english <- merge(english,eng_prof,by='partNum')
eng_att <- blp_attitude_score[blp_attitude_score$question_language == 'English',]
names(eng_att)[names(eng_att)=='langAttResp'] <- 'eng_att_score'
eng_att <- select(eng_att, -c(question_language))
english <- merge(english,eng_att,by='partNum')
eng_score <- with(english,(eng_hist_score*0.454+eng_use_score*1.09+eng_prof_score*2.27+eng_att_score*2.27))
english$eng_score <- eng_score

# Spanish scores
esp_hist <- blp_history_score[blp_history_score$question_language == 'Spanish',]
names(esp_hist)[names(esp_hist)=='langHistResp'] <- 'esp_hist_score'
esp_hist <- select(esp_hist, -c(question_language))
esp_use <- blp_use_score[blp_use_score$question_language == 'Spanish',]
names(esp_use)[names(esp_use)=='langUseResp'] <- 'esp_use_score'
esp_use <- select(esp_use, -c(question_language))
spanish <- merge(esp_hist,esp_use,by='partNum')
esp_prof <- blp_proficiency_score[blp_proficiency_score$question_language == 'Spanish',]
names(esp_prof)[names(esp_prof)=='langProfResp'] <- 'esp_prof_score'
esp_prof <- select(esp_prof, -c(question_language))
spanish <- merge(spanish,esp_prof,by='partNum')
esp_att <- blp_attitude_score[blp_attitude_score$question_language == 'Spanish',]
names(esp_att)[names(esp_att)=='langAttResp'] <- 'esp_att_score'
esp_att <- select(esp_att, -c(question_language))
spanish <- merge(spanish,esp_att,by='partNum')
esp_score <- with(spanish,(esp_hist_score*0.454+esp_use_score*1.09+esp_prof_score*2.27+esp_att_score*2.27))
spanish$esp_score <- esp_score

global_score <- merge(english, spanish,  by='partNum')
# check that all values are between 0 and 218
min(global_score$eng_score)
min(global_score$esp_score)
max(global_score$eng_score)
max(global_score$esp_score)

# get language dominance score
# positive numbers indicate English dominance
# negative numbers indicate Spanish dominance
# near 0 indicates more balanced bilinguals
lang_dom <- with(global_score,eng_score-esp_score)
global_score$lang_dominance <- lang_dom
global_score <- merge(global_score, lex_eng_score, by='partNum')
global_score <- merge(global_score, lex_esp_score, by='partNum')
part_scores <- select(global_score, c(partNum,eng_score,esp_score,lang_dominance,lextale_eng_correct, lextale_esp_correct))
part_scores_demographics <- merge(part_scores,demographics, by='partNum')

rm(eng_score,esp_score,lang_dom, blp_data_cleaned,blp_attitude_score,blp_history_score,blp_proficiency_score,blp_use_score)
rm(eng_att,eng_hist,eng_prof,eng_use,esp_att,esp_hist,esp_prof,esp_use)
rm(global_score, english, spanish, part_scores,lex_esp_score, lex_eng_score, demographics)

# export csv for Miquel Meeting
write_csv(lang_attitude_clean,'~/Desktop/working_diss_files/r-checking/blp_attitude.csv')
write_csv(lang_history_clean,'~/Desktop/working_diss_files/r-checking/blp_history.csv')
write_csv(lang_proficiency_clean,'~/Desktop/working_diss_files/r-checking/blp_proficiency.csv')
write_csv(lang_use_clean,'~/Desktop/working_diss_files/r-checking/blp_use.csv')
write_csv(lex_eng_cleaned,'~/Desktop/working_diss_files/r-checking/lextale_english.csv')
write_csv(lex_esp_cleaned,'~/Desktop/working_diss_files/r-checking/lextale_spanish.csv')
write_csv(part_scores_demographics,'~/Desktop/working_diss_files/r-checking/participants_information.csv')
