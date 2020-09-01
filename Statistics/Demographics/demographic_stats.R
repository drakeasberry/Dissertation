#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(plyr)
library(readr)
library(tidyverse)
library(psych)
library(lattice)

# Create 'not in' function
'%ni%' <- Negate('%in%')

# Surpress all readr messages by default
# https://www.reddit.com/r/rstats/comments/739vf6/how_to_turn_off_readrs_messages_by_default/
options(readr.num_columns = 0)

# Read in group to participant mapping
group_map <- read_csv('../../Scripts_Dissertation/participant_group_map.csv')

# LexTALE-English Data Directory
lex_eng_dir = 'analyze_data/lextale_eng_cols' #set path to directory
lex_eng_files = list.files(path=lex_eng_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path
#print(engFiles)

# read in all the files into one data frame
lex_eng_data = ldply(lex_eng_files, read_csv)
write_csv(lex_eng_data, 'eng_lextale_raw.csv')

# Add Group to table and remove Demographic
lex_eng_data <- lex_eng_data %>% 
  left_join(group_map, by = 'partNum')
  
lex_eng_no_heritage <- subset(lex_eng_data, lex_eng_data$group != 'Childhood')

lex_eng_no_heritage %>% 
  group_by(group) %>% 
  summarise(count = n_distinct(partNum)) 
  
lex_eng_data <-  lex_eng_no_heritage %>%   
  select("partNum", "group", "word", "translation", "corrAnsEngV", "corrAns", "lextaleRespEng", 
         "lextaleRespEngCorr", "lextaleRespEngRT")
rm(lex_eng_no_heritage, lex_eng_dir, lex_eng_files)

# LexTALE-Spanish Data Directory
lex_esp_dir = 'analyze_data/lextale_esp_cols' #set path to directory
lex_esp_files = list.files(path=lex_esp_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path

# read in all the files into one data frame
lex_esp_data = ldply(lex_esp_files, read_csv)
write_csv(lex_esp_data, 'esp_lextale_raw.csv')

# Add Group to table and remove Demographic
lex_esp_data <- lex_esp_data %>% 
  left_join(group_map, by = 'partNum')

lex_esp_no_heritage <- subset(lex_esp_data, lex_esp_data$group != 'Childhood')

lex_esp_no_heritage %>% 
  group_by(group) %>% 
  summarise(count = n_distinct(partNum)) 

lex_esp_data <-  lex_esp_no_heritage %>%   
  select("partNum", "group", "word", "translation", "corrAnsEspV", "corrAns", "lextaleRespEsp", 
         "lextaleRespEspCorr", "lextaleRespEspRT")

rm(lex_esp_no_heritage, lex_esp_dir, lex_esp_files)

## subset for those collected in person
#bi_mx_lex_esp <- subset(lex_esp_data, is.na(lex_esp_data$OS) & lex_esp_data$placeResidence == 'Hermosillo')
#lex_esp <- subset(lex_esp_data, is.na(lex_esp_data$OS))
#
## subset for those collected online
#mono_lex_esp <- subset(lex_esp_data, !is.na(lex_esp_data$OS) & lex_esp_data$birthCountry == 'México')

# Basic Langauge Profile Data Directory
blp_dir = 'analyze_data/blp_cols' #set path to directory
blp_files = list.files(path=blp_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path

# read in all the files into one data frame
blp_data = ldply(blp_files, read_csv)

# Add Group to table and remove Demographic
blp_data <- blp_data %>% 
  left_join(group_map, by = 'partNum')

blp_no_heritage <- subset(blp_data, blp_data$group != 'Childhood')

blp_no_heritage %>% 
  group_by(group) %>% 
  summarise(count = n_distinct(partNum)) 

blp_data <-  blp_no_heritage %>%   
  select("partNum", "group", "sectionEng", "questionTextEng", "languageEng", "langHistResp1",
         "langHistRT1", "langHistResp2", "langHistRT2", "langHistResp", "langHistRT", "langUseResp",
         "langUseRT", "langProfResp", "langProfRT", "langAttResp", "langAttRT")

# remove unnecessary values from Rstudio Environment
rm(blp_no_heritage, blp_dir, blp_files)

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
blp_data_cleaned <- select(blp_data, -c(langHistResp1, langHistRT1, langHistResp2, langHistRT2))

## subset experimental and participant information 
#demographics <- select(blp_data_cleaned, 'partNum':'expName')
#demographics <- demographics[!duplicated(demographics$partNum),] # reduce to one row per participant

# deletes practice rows in LexTALE test
lex_eng_cleaned <- lex_eng_data %>%
  subset(word != 'platery') %>%
  subset(word != 'denial') %>%
  subset(word != 'generic')

# Create csv without practice trials
write_csv(lex_eng_cleaned, 'eng_lextale.csv')

lex_esp_cleaned <- lex_esp_data %>%
  subset(word != 'pladeno') %>%
  subset(word != 'delantera') %>%
  subset(word != 'garbardina')

# Create csv without practice trials
write_csv(lex_esp_cleaned, 'esp_lextale.csv')
#
#bi_mx_lex_esp_cleaned <- bi_mx_lex_esp %>%
#  subset(word != 'pladeno') %>%
#  subset(word != 'delantera') %>%
#  subset(word != 'garbardina')
#
#mono_lex_esp_cleaned <- mono_lex_esp %>%
#  subset(word != 'pladeno') %>%
#  subset(word != 'delantera') %>%
#  subset(word != 'garbardina')

rm(lex_eng_data, lex_esp_data, blp_data,i, j)

## Read vector from R session Monolingual Lemma Segmentation Visual
#segmentation_remaining <- readRDS("online_lemma_participants")
#mono_lex_esp_cleaned <- subset(mono_lex_esp_cleaned, mono_lex_esp_cleaned$partNum %in% segmentation_remaining)
#write_csv(mono_lex_esp_cleaned, '44_monolingual_lextale_all_responses.csv')

# get LexTALE scores
# commented lines only for quick viewing purposes, NOT analysis
#lex_eng_score <- aggregate(data=lex_eng_cleaned, lexRespEngCorr ~ partNum + birthCountry, FUN='mean')
#lex_esp_score <- aggregate(data=lex_esp_cleaned, lexRespEspCorr ~ partNum + birthCountry, FUN='mean')
lex_eng_score <- aggregate(data=lex_eng_cleaned, lextaleRespEngCorr ~ partNum, FUN='mean')
names(lex_eng_score)[names(lex_eng_score)=='lextaleRespEngCorr'] <- 'lextale_eng_correct'
# write file with participant number and english lextale score
write_csv(lex_eng_score, 'eng_lex_score.csv')

lex_esp_score <- aggregate(data=lex_esp_cleaned, lextaleRespEspCorr ~ partNum, FUN='mean')
names(lex_esp_score)[names(lex_esp_score)=='lextaleRespEspCorr'] <- 'lextale_esp_correct'
# write file with participant number and english lextale score
write_csv(lex_esp_score, 'esp_lex_score.csv')

# Izura method of calculation Monolinguals
esp_real_word <- subset(lex_esp_cleaned,lex_esp_cleaned$translation != "NW" & lex_esp_cleaned$lextaleRespEspCorr == 1) 

esp_non_word <- subset(lex_esp_cleaned,lex_esp_cleaned$translation == "NW")# & mono_lex_esp_cleaned$lextaleRespEspCorr == 0)

esp_wd_corr <- aggregate(data=esp_real_word, lextaleRespEspCorr ~ partNum, FUN='sum')
names(esp_wd_corr)[names(esp_wd_corr)=='lextaleRespEspCorr'] <- 'yes_to_word'
esp_nw_incorr <- aggregate(data=esp_non_word, lextaleRespEspCorr ~ partNum, FUN='sum')
esp_nw_incorr <- esp_nw_incorr %>% 
  add_column(., yes_to_nonword = 30 - esp_nw_incorr$lextaleRespEspCorr) %>% 
  select(.,-c('lextaleRespEspCorr'))


esp_lex_esp_izura <- merge(esp_wd_corr, esp_nw_incorr, by='partNum') %>% 
  add_column(.,izura_score = .$yes_to_word - 2 * .$yes_to_nonword)# %>% 
  #subset(.,.$partNum %in% segmentation_remaining)

write_csv(esp_lex_esp_izura, '206_izura_score.csv')

# All participants Lextale-Esp distribution plots
densityplot(~izura_score, data = esp_lex_esp_izura, main = 'Density plot of All participants') 
histogram(~izura_score, data = esp_lex_esp_izura, main = 'All participants collected') 

# All participants Lextale-Esp descriptive statistics 
describe(esp_lex_esp_izura$izura_score)

rm(esp_non_word, esp_nw_incorr, esp_real_word, esp_wd_corr, lex_eng_cleaned, lex_esp_cleaned)

## Monolingual Spanish Speakers from Mexico
#mono_lex_esp_score <- aggregate(data=mono_lex_esp_cleaned, lextaleRespEspCorr ~ partNum, FUN='mean')
#names(mono_lex_esp_score)[names(mono_lex_esp_score)=='lextaleRespEspCorr'] <- 'lextale_esp_correct'
#
## Izura method of calculation Monolinguals
#mono_real_word <- subset(mono_lex_esp_cleaned,mono_lex_esp_cleaned$translation != "NW" & mono_lex_esp_cleaned$lextaleRespEspCorr == 1) 
#  
#mono_non_word <- subset(mono_lex_esp_cleaned,mono_lex_esp_cleaned$translation == "NW")# & mono_lex_esp_cleaned$lextaleRespEspCorr == 0)
#
#mono_wd_corr <- aggregate(data=mono_real_word, lextaleRespEspCorr ~ partNum, FUN='sum')
#names(mono_wd_corr)[names(mono_wd_corr)=='lextaleRespEspCorr'] <- 'yes_to_word'
#mono_nw_incorr <- aggregate(data=mono_non_word, lextaleRespEspCorr ~ partNum, FUN='sum')
#mono_nw_incorr <- mono_nw_incorr %>% 
#  add_column(., yes_to_nonword = 30 - mono_nw_incorr$lextaleRespEspCorr) %>% 
#  select(.,-c('lextaleRespEspCorr'))
#
#
#mono_lex_esp_izura <- merge(mono_wd_corr, mono_nw_incorr, by='partNum') %>% 
#  add_column(.,izura_score = .$yes_to_word - 2 * .$yes_to_nonword) %>% 
#  subset(.,.$partNum %in% segmentation_remaining)
#
#write_csv(mono_lex_esp_izura, '44_monolingual_izura_score.csv')
#
## Monolingual Lextale-Esp distribution plots
#densityplot(~izura_score, data = mono_lex_esp_izura, main = 'Density plot of Monolingual participants') 
#histogram(~izura_score, data = mono_lex_esp_izura, main = 'Monolingual participants collected online') 
#
## Monolingual Lextale-Esp descriptive statistics 
#describe(mono_lex_esp_izura$izura_score)

#mono_below_34 <- subset(mono_lex_esp_izura,mono_lex_esp_izura$izura_score < 34)
#mono_below_30 <- subset(mono_lex_esp_izura,mono_lex_esp_izura$izura_score < 30)
#mono_below_20 <- subset(mono_lex_esp_izura,mono_lex_esp_izura$izura_score < 20)
#mono_below_10 <- subset(mono_lex_esp_izura,mono_lex_esp_izura$izura_score < 10)
#
#
#remaining_46 <- subset(mono_lex_esp_izura,mono_lex_esp_izura$partNum %in% segmentation_remaining)
#
#densityplot(~izura_score, data = remaining_46, main = 'Density plot of all 46 participants not cut from segmentation criteria') 
#histogram(~izura_score, data = remaining_46, main = ' 46 participants not cut from segmentation criteria') 
#
#remaining_below_30 <- subset(remaining_46, remaining_46$izura_score < 30)  



## Izura method of calculatio Spanish bilinguals from Mexico
#bi_mx_lex_esp <- subset(bi_mx_lex_esp_cleaned, bi_mx_lex_esp_cleaned$birthCountry == 'México')
#bi_mx_real_word <- subset(bi_mx_lex_esp,bi_mx_lex_esp$translation != "NW" & bi_mx_lex_esp$lextaleRespEspCorr == 1) #
#
#bi_mx_non_word <- subset(bi_mx_lex_esp,bi_mx_lex_esp$translation == "NW")# & mono_lex_esp_cleaned$lextaleRespEspCo#rr == 0)
#
#bi_mx_wd_corr <- aggregate(data=bi_mx_real_word, lextaleRespEspCorr ~ partNum, FUN='sum')
#names(bi_mx_wd_corr)[names(bi_mx_wd_corr)=='lextaleRespEspCorr'] <- 'yes_to_word'
#
#bi_mx_nw_incorr <- aggregate(data=bi_mx_non_word, lextaleRespEspCorr ~ partNum, FUN='sum') 
#
#bi_mx_nw_incorr <- add_column(bi_mx_nw_incorr, yes_to_nonword = 30 - bi_mx_nw_incorr$lextaleRespEspCorr) %>% 
#  select(.,-c('lextaleRespEspCorr'))
#
#
#bi_mx_lex_esp_izura <- merge(bi_mx_wd_corr, bi_mx_nw_incorr, by='partNum') %>% 
#  add_column(.,izura_score = .$yes_to_word - 2 * .$yes_to_nonword)
#
#bi_mx_below_34 <- subset(bi_mx_lex_esp_izura,bi_mx_lex_esp_izura$izura_score < 34)

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
rm(lang_history,lang_use,lang_proficiency,lang_attitude)

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

# write csv with global scores
write_csv(global_score, 'blp_global_scores.csv')

# get language dominance score
# positive numbers indicate English dominance
# negative numbers indicate Spanish dominance
# near 0 indicates more balanced bilinguals
lang_dom <- with(global_score,eng_score-esp_score)
global_score$lang_dominance <- lang_dom

part_score <- merge(global_score, lex_eng_score, by='partNum') %>% 
  full_join(., lex_esp_score, by='partNum') %>% 
  left_join(., group_map, by = 'partNum') %>% 
  left_join(., esp_lex_esp_izura, by = 'partNum')
part_score <- part_score %>%  
  select("partNum", "group", everything())


#part_scores <- select(global_score, c(partNum,eng_score,esp_score,lang_dominance,lextale_eng_correct, lextale_esp_correct))

#part_scores_demographics <- merge(part_scores,demographics, by='partNum')

#write_csv(part_scores_demographics, 'blp_lextale_lab_participants.csv')

rm(eng_score,esp_score,lang_dom, blp_data_cleaned,blp_attitude_score,blp_history_score,
   blp_proficiency_score,blp_use_score, eng_att,eng_hist,eng_prof,eng_use,esp_att,esp_hist,
   esp_prof,esp_use, english, spanish, part_scores, lex_esp_score, lex_eng_score, demographics,
   lang_attitude_clean, lang_history_clean, lang_proficiency_clean, lang_use_clean,
   esp_lex_esp_izura, global_score)

# Need to create data set for demographics One line per participant
# demogrpahics_all.csv
# Create subset for Intuition Experiment, Lexical Access and Segmenation Experiment (lab), Segmenation (online)
# intuition_demo.csv, lexical_access_demo.csv, segmentation_lab_demo.csv, segmentation_online_demo.csv
# partID, LexTALE-ENG, LexTale-ESP, Bilingual Langauge Profile
# Store in Box > Intuition > Active > data > attirbutes

lab_part = read_csv('blp_lextale_lab_participants.csv')

# export csv for Miquel Meeting
write_csv(lang_attitude_clean,'~/Desktop/working_diss_files/r-checking/blp_attitude.csv')
write_csv(lang_history_clean,'~/Desktop/working_diss_files/r-checking/blp_history.csv')
write_csv(lang_proficiency_clean,'~/Desktop/working_diss_files/r-checking/blp_proficiency.csv')
write_csv(lang_use_clean,'~/Desktop/working_diss_files/r-checking/blp_use.csv')
write_csv(lex_eng_cleaned,'~/Desktop/working_diss_files/r-checking/lextale_english.csv')
write_csv(lex_esp_cleaned,'~/Desktop/working_diss_files/r-checking/lextale_spanish.csv')
write_csv(part_scores_demographics,'~/Desktop/working_diss_files/r-checking/participants_information.csv')
