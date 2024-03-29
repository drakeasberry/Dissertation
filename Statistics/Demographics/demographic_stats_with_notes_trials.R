#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(plyr)
library(readr)
library(tidyverse)
library(psych)
library(lattice)
library(tidyr)

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
#write_csv(lex_eng_data, 'eng_lextale_raw.csv')

# Add Group to table and remove Demographic
lex_eng_data <- lex_eng_data %>% 
  left_join(group_map, by = 'partNum')

# Remove heritage participants  
lex_eng_no_heritage <- subset(lex_eng_data, lex_eng_data$group != 'Childhood')

# Check numbers while debugging
lex_eng_no_heritage %>% 
  group_by(group) %>% 
  summarise(count = n_distinct(partNum)) 

# Select columns to keep without heritage participant data  
lex_eng_data <-  lex_eng_no_heritage %>%   
  select("partNum", "group", "word", "translation", "corrAnsEngV", "corrAns", "lextaleRespEng", 
         "lextaleRespEngCorr", "lextaleRespEngRT")

# clean up data
rm(lex_eng_no_heritage, lex_eng_dir, lex_eng_files)

# LexTALE-Spanish Data Directory
lex_esp_dir = 'analyze_data/lextale_esp_cols' #set path to directory
lex_esp_files = list.files(path=lex_esp_dir, pattern = '*.csv', full.names = TRUE) #list all the files with path

# read in all the files into one data frame
lex_esp_data = ldply(lex_esp_files, read_csv)
#write_csv(lex_esp_data, 'esp_lextale_raw.csv')

# Add Group to table and remove Demographic
lex_esp_data <- lex_esp_data %>% 
  left_join(group_map, by = 'partNum')

# Remove heritage participant data
lex_esp_no_heritage <- subset(lex_esp_data, lex_esp_data$group != 'Childhood')

# Check numbers while debugging
lex_esp_no_heritage %>% 
  group_by(group) %>% 
  summarise(count = n_distinct(partNum)) 

# Select columns to keep without heritage participant data
lex_esp_data <-  lex_esp_no_heritage %>%   
  select("partNum", "group", "word", "translation", "corrAnsEspV", "corrAns", "lextaleRespEsp", 
         "lextaleRespEspCorr", "lextaleRespEspRT")

# clean up data environemnt
rm(lex_esp_no_heritage, lex_esp_dir)



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

# Remove Heritage participant data
blp_no_heritage <- subset(blp_data, blp_data$group != 'Childhood')

# Check numbers while debugging
blp_no_heritage %>% 
  group_by(group) %>% 
  summarise(count = n_distinct(partNum)) 

# Select columns to keep without heritage participant data
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
#write_csv(lex_eng_cleaned, 'eng_lextale.csv')

lex_esp_cleaned <- lex_esp_data %>%
  subset(word != 'pladeno') %>%
  subset(word != 'delantera') %>%
  subset(word != 'garbardina')

# Create csv without practice trials
#write_csv(lex_esp_cleaned, 'esp_lextale.csv')



#bi_mx_lex_esp_cleaned <- bi_mx_lex_esp %>%
#  subset(word != 'pladeno') %>%
#  subset(word != 'delantera') %>%
#  subset(word != 'garbardina')
#
#mono_lex_esp_cleaned <- mono_lex_esp %>%
#  subset(word != 'pladeno') %>%
#  subset(word != 'delantera') %>%
#  subset(word != 'garbardina')



# Clean up data environment
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
#write_csv(lex_eng_score, 'eng_lex_score.csv')

lex_esp_score <- aggregate(data=lex_esp_cleaned, lextaleRespEspCorr ~ partNum, FUN='mean')
names(lex_esp_score)[names(lex_esp_score)=='lextaleRespEspCorr'] <- 'lextale_esp_correct'
# write file with participant number and english lextale score
#write_csv(lex_esp_score, 'esp_lex_score.csv')

# Izura method of calculation Monolinguals
# Get all real words that were answered correctly
esp_real_word <- subset(lex_esp_cleaned,lex_esp_cleaned$translation != "NW" & lex_esp_cleaned$lextaleRespEspCorr == 1) 

# Get all nonword data
esp_non_word <- subset(lex_esp_cleaned,lex_esp_cleaned$translation == "NW")

# Sum word response data by participant and rename column
esp_wd_corr <- aggregate(data=esp_real_word, lextaleRespEspCorr ~ partNum, FUN='sum')
names(esp_wd_corr)[names(esp_wd_corr)=='lextaleRespEspCorr'] <- 'yes_to_word'

# Sum all incorrect responses to non words by participant
esp_nw_incorr <- aggregate(data=esp_non_word, lextaleRespEspCorr ~ partNum, FUN='sum')
# Add column to dataframe to storing number of incorrect responses to nonwords
esp_nw_incorr <- esp_nw_incorr %>% 
  add_column(., yes_to_nonword = 30 - esp_nw_incorr$lextaleRespEspCorr) %>% 
  select(.,-c('lextaleRespEspCorr'))

# merge real word and non word dataframe into one and store calculated izura score
esp_lex_esp_izura <- merge(esp_wd_corr, esp_nw_incorr, by='partNum') %>% 
  add_column(.,izura_score = .$yes_to_word - 2 * .$yes_to_nonword)
  

# Keep write statement
#write_csv(esp_lex_esp_izura, '206_izura_score.csv')

# All participants Lextale-Esp distribution plots
densityplot(~izura_score, data = esp_lex_esp_izura, main = 'Density plot of All participants') 
histogram(~izura_score, data = esp_lex_esp_izura, main = 'All participants collected') 

# All participants Lextale-Esp descriptive statistics 
describe(esp_lex_esp_izura$izura_score)

# Clean up data environment
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
# create language history dataframe
lang_history <- subset(blp_data_cleaned, blp_section == 'Language history')
lang_history_clean <- select(lang_history, -c(langUseResp,langUseRT,langProfResp,langProfRT,langAttResp, langAttRT))
# create language use dataframe
lang_use <- subset(blp_data_cleaned, blp_section == 'Language use')
lang_use_clean <- select(lang_use, -c(langHistResp,langHistRT,langProfResp,langProfRT,langAttResp, langAttRT))
# create language proficiency dataframe
lang_proficiency <- subset(blp_data_cleaned, blp_section == 'Language proficiency')
lang_proficiency_clean <- select(lang_proficiency, -c(langHistResp,langHistRT,langUseResp,langUseRT,langAttResp, langAttRT))
# create language attitude dataframe
lang_attitude <- subset(blp_data_cleaned, blp_section == 'Language attitudes')
lang_attitude_clean <- select(lang_attitude, -c(langHistResp,langHistRT,langUseResp,langUseRT,langProfResp,langProfRT))

# remove raw files imported in Rstudio environment
rm(lang_history,lang_use,lang_proficiency,lang_attitude)

# create blp score tables
# basic language profile history score
blp_history_score <- aggregate(data=lang_history_clean, langHistResp ~ partNum + question_language, FUN='sum')
# basic language profile use score
blp_use_score <- aggregate(data=lang_use_clean, langUseResp ~ partNum + question_language, FUN='sum')
# basic language profile proficiency score
blp_proficiency_score <- aggregate(data=lang_proficiency_clean, langProfResp ~ partNum + question_language, FUN='sum')
# basic language profile attitude score
blp_attitude_score <- aggregate(data=lang_attitude_clean, langAttResp ~ partNum + question_language, FUN='sum')

# Global Language Scores from BLP Calculation
# English Scores
# history score and rename column
eng_hist <- blp_history_score[blp_history_score$question_language == 'English',]
names(eng_hist)[names(eng_hist)=='langHistResp'] <- 'eng_hist_score'
eng_hist <- select(eng_hist, -c(question_language))
# use score and rename column
eng_use <- blp_use_score[blp_use_score$question_language == 'English',]
names(eng_use)[names(eng_use)=='langUseResp'] <- 'eng_use_score'
eng_use <- select(eng_use, -c(question_language))
# merge history and use dataframes
english <- merge(eng_hist,eng_use,by='partNum')
# proficiency score and rename column
eng_prof <- blp_proficiency_score[blp_proficiency_score$question_language == 'English',]
names(eng_prof)[names(eng_prof)=='langProfResp'] <- 'eng_prof_score'
eng_prof <- select(eng_prof, -c(question_language))
# add proficiency score to merged dataframe with history and use
english <- merge(english,eng_prof,by='partNum')
# attitude score and rename column
eng_att <- blp_attitude_score[blp_attitude_score$question_language == 'English',]
names(eng_att)[names(eng_att)=='langAttResp'] <- 'eng_att_score'
eng_att <- select(eng_att, -c(question_language))
# add attitude score to merged dataframe with history, use and proficiency
english <- merge(english,eng_att,by='partNum')
# add column with calculation of global score
eng_score <- with(english,(eng_hist_score*0.454+eng_use_score*1.09+eng_prof_score*2.27+eng_att_score*2.27))
# add English calculated score to dataframe containing individual section scores
english$eng_score <- eng_score

# Spanish scores
# history score and rename column
esp_hist <- blp_history_score[blp_history_score$question_language == 'Spanish',]
names(esp_hist)[names(esp_hist)=='langHistResp'] <- 'esp_hist_score'
esp_hist <- select(esp_hist, -c(question_language))
# use score and rename column
esp_use <- blp_use_score[blp_use_score$question_language == 'Spanish',]
names(esp_use)[names(esp_use)=='langUseResp'] <- 'esp_use_score'
esp_use <- select(esp_use, -c(question_language))
# merge history and use dataframes
spanish <- merge(esp_hist,esp_use,by='partNum')
# proficiency score and rename column
esp_prof <- blp_proficiency_score[blp_proficiency_score$question_language == 'Spanish',]
names(esp_prof)[names(esp_prof)=='langProfResp'] <- 'esp_prof_score'
esp_prof <- select(esp_prof, -c(question_language))
# add proficiency score to merged dataframe with history and use
spanish <- merge(spanish,esp_prof,by='partNum')
# attitude score and rename column
esp_att <- blp_attitude_score[blp_attitude_score$question_language == 'Spanish',]
names(esp_att)[names(esp_att)=='langAttResp'] <- 'esp_att_score'
esp_att <- select(esp_att, -c(question_language))
# add attitude score to merged dataframe with history, use and proficiency
spanish <- merge(spanish,esp_att,by='partNum')
# add column with calculation of global score
esp_score <- with(spanish,(esp_hist_score*0.454+esp_use_score*1.09+esp_prof_score*2.27+esp_att_score*2.27))
# add English calculated score to dataframe containing individual section scores
spanish$esp_score <- esp_score

# Merge table with English and Spanish global scores from BLP
global_score <- merge(english, spanish,  by='partNum')

# check that all values are between 0 and 218
min(global_score$eng_score)
min(global_score$esp_score)
max(global_score$eng_score)
max(global_score$esp_score)

# write csv with global scores
#write_csv(global_score, 'blp_global_scores.csv')

# get language dominance score
# positive numbers indicate English dominance
# negative numbers indicate Spanish dominance
# near 0 indicates more balanced bilinguals
lang_dom <- with(global_score,eng_score-esp_score)
global_score$lang_dominance <- lang_dom

part_score <- merge(global_score, lex_eng_score, by='partNum') %>% 
  full_join(., lex_esp_score, by='partNum') %>% 
  left_join(., group_map, by = 'partNum') %>% 
  left_join(., esp_lex_esp_izura, by = 'partNum') %>% 
  select("partNum", "group", everything()) %>% 
  rename(global_eng_score = eng_score, global_esp_score = esp_score, 
         izura_yes_to_words = yes_to_word, izura_yes_to_nonwords = yes_to_nonword)


#part_scores <- select(global_score, c(partNum,eng_score,esp_score,lang_dominance,lextale_eng_correct, lextale_esp_correct))

#part_scores_demographics <- merge(part_scores,demographics, by='partNum')

#write_csv(part_scores_demographics, 'blp_lextale_lab_participants.csv')

# Clean up data environment
rm(eng_score,esp_score,lang_dom, blp_data_cleaned,blp_attitude_score,blp_history_score,
   blp_proficiency_score,blp_use_score, eng_att,eng_hist,eng_prof,eng_use,esp_att,esp_hist,
   esp_prof,esp_use, english, spanish, lex_esp_score, lex_eng_score, lang_attitude_clean, 
   lang_history_clean, lang_proficiency_clean, lang_use_clean, esp_lex_esp_izura, global_score, 
   group_map)

# Add additional demographic data from Prolific
L2_demo <- read_csv('L2_demographics.csv')
mono_demo <- read_csv('monolingual_demographics.csv') %>% 
  add_column("Fluent languages" = NA) %>% 
  add_column("Were you raised monolingual?" = NA)
online_demo <- rbind(L2_demo,mono_demo)

rm(mono_demo, L2_demo)

# Additional demogrpahic data from PsychoPy
# read in all the files into one data frame
demographics <- ldply(lex_esp_files, read_csv)
demographics <- demographics %>% 
  select(c("partNum":"expName", "raisedCountry":"last_class")) %>% 
  left_join(online_demo, by = 'partNum') %>%
  #left_join(group_map, by = 'partNum') %>% 
  left_join(part_score, by = 'partNum') %>% 
  distinct()

# clean up data environment
rm(online_demo, part_score)

# Create table for all demographic information for participants in lab segmentation experiment
lab_segmentation <- subset(demographics, expName == 'Segmentation') %>% 
  select_if(~!all(is.na(.))) %>% 
  subset(., group != 'Childhood') %>% 
  select(-c('expName')) %>% 
  rename(age = age.x) %>% 
  select(c('partNum','eng_hist_score':'izura_score', 'age':'preferLanguage','group','session',
            'date'))

# Write statement for file containing only necessary columns for lab segmentation analysis
write_csv(lab_segmentation, '53_lab_segmentation.csv')
# For PI Advisor
write_csv(lab_segmentation, 'lab_segmentation_attributes.csv')

# This needs some work because several participants returned 2nd time and are listed only under
#segmentation
#lab_lexical <- subset(demographics, expName == 'Lexical_Access') %>% 
#  select_if(~!all(is.na(.))) %>% 
#  subset(., group != 'Childhood') %>% 
#  select(-c('expName')) %>% 
#  rename(age = age.x) %>% 
#  select(c('partNum','eng_hist_score':'izura_score', 'age':'preferLanguage','group','session',
#           'date'))

# Create table for all demographic information for participants in intuition experiment  
lab_intuition <- subset(demographics, expName != 'lemma_segmentation') %>%
  select_if(~!all(is.na(.))) %>% 
  subset(., group != 'Childhood') %>% 
  rename(age = age.x) %>% 
  select(c('partNum','eng_hist_score':'izura_score', 'age':'preferLanguage','group','session',
           'expName', 'date'))

# Write statement for file containing only necessary columns for lab intuition analysis
write_csv(lab_intuition, '74_lab_intuition.csv')
# For PI Advisor
write_csv(lab_intuition, 'lab_intuition_attributes.csv')

# Create table for all demographic information for participants in online experiments
# Dropped for error rates in experiment
mono_error_drop <- c("part202", "part210", "part223", "part227", "part232", "part253") # n=6
L2_error_drop <- c("part255", "part270", "part275", "part277", "part290", "part291",
                   "part292", "part293", "part301", "part303", "part305", "part309",
                   "part327", "part332", "part333") # n=15

# Dropped for demographic information outside scope of project
online_demo_drop <- c("part205","part221","part226", "part251", "part252", "part259", "part263", 
                 "part267", "part280", "part284", "part287", "part294", "part315") # n=13

# Combine all dropped participants
online_drop <- c(mono_error_drop, L2_error_drop, online_demo_drop) # n=34

online_lemma <- subset(demographics, expName == 'lemma_segmentation') %>% 
  select_if(~!all(is.na(.))) %>%
  rename(birth_country = `Country of Birth`, acquisition_age = first_learning,
         employed = `Employment Status`, native_lang = `First Language`,
         fluent_lang = `Fluent languages`, student = `Student Status`,
         raised_monolingual = `Were you raised monolingual?`) %>% 
  mutate(age = ifelse(is.na(age.y), age.x, age.y),
         current_residence = ifelse(is.na(`Current Country of Residence`), 
                                    placeResidence, `Current Country of Residence`),
         current_residence = ifelse(current_residence == "Estados Unidos", "United States",
                                    current_residence),
         preferLanguage = ifelse(preferLanguage == 'English', 'inglés', preferLanguage),
         houseLanguage = ifelse(houseLanguage == 'English', 'inglés', houseLanguage),
         Bilingual = ifelse(Bilingual == 'I know one other language in addition to English',  
                             'native language + one other language', Bilingual),
         Bilingual = ifelse(Bilingual == 'Not Used',  
                            'native language + one other language', Bilingual),
         acquisition_age = ifelse(acquisition_age == 'seis', 6, acquisition_age),
         acquisition_age = ifelse(acquisition_age == 'A los 12 años de edad', 12, acquisition_age),
         acquisition_age = ifelse(acquisition_age == 'a los 5 anos', 5, acquisition_age),
         acquisition_age = ifelse(acquisition_age == 'con mi esposo', 99, acquisition_age),
         speaking = ifelse(speaking == 'intermediate', 'intermedio', speaking),
         listening = ifelse(listening == 'intermediate', 'intermedio', listening),
         reading = ifelse(reading == 'intermediate', 'intermedio', reading),
         writing = ifelse(writing == 'intermediate', 'intermedio', writing),
         last_class = ifelse(last_class == 'a year ago', 'hace un año', last_class),
         fluent_lang = ifelse(fluent_lang == 'Spanish, English', 'English, Spanish', fluent_lang),
         education = ifelse(education == "University (diploma, bachelor's degree)", 
                            "Universidad (diplomatura, licenciatura)", education),
         raisedCountry = ifelse(raisedCountry == 'U.S', 'Estados Unidos', raisedCountry)) %>%
  subset(., partNum %ni% online_drop) %>% 
  select(c('partNum', 'group':'izura_score', 'age', 'acquisition_age':'last_class', 
           'native_lang', 'preferLanguage', 'houseLanguage', 'Bilingual', 'raised_monolingual', 
           'fluent_lang', 'Nationality', 'birth_country', 'raisedCountry', 'current_residence', 
           'Sex', 'education', 'student', 'employed', 'date','OS'))

natives <- subset(online_lemma, group == 'Monolingual Spanish')
learners <- subset(online_lemma, group == 'L2 Learner')

# Write csv files for PI Advisor
write_csv(natives, 'natives.csv')
write_csv(learners, 'learners.csv')

# Write statement for file containing only necessary columns for online segmentation analysis
#write_csv(online_lemma, '120_lemma_online.csv')
# For PI Advisor
#write_csv(online_lemma, 'online_attributes.csv')
  
# Used to check values. not part of final code
#colnames(online_lemma)
#select(online_lemma, c('partNum', 'native_lang', 'Bilingual')) #%>% 
#  filter(group == 'L2 Learner')

# Subset online experiment for Monolingual Speakers from Mexico
#mono_lemma <- subset(online_lemma, group == 'Monolingual Spanish') %>% 
#  select_if(~!all(is.na(.)))
#
## Write statement for file containing only necessary columns for online segmentation analysis
#write_csv(mono_lemma, '50_lemma_online.csv')
## For PI Advisor
#write_csv(mono_lemma, 'online_mono_attributes.csv')
#
## Subset online experiment for L2 Spanish Speakers from US
#L2_lemma <- subset(online_lemma, group == 'L2 Learner')
#
## Write statement for file containing only necessary columns for online segmentation analysis
#write_csv(L2_lemma, '70_lemma_online.csv')
## For PI Advisor
#write_csv(L2_lemma, 'online_L2_attributes.csv')

# Used to check columns and values
lapply(lab_segmentation, function(x) length(table(x)))
sapply(lab_segmentation,function(x) unique(x))
lapply(lab_intuition, function(x) length(table(x)))
sapply(lab_intuition,function(x) unique(x))
lapply(online_lemma, function(x) length(table(x)))
sapply(online_lemma,function(x) unique(x))
lapply(natives, function(x) length(table(x)))
sapply(natives,function(x) unique(x))
lapply(learners, function(x) length(table(x)))
sapply(learners,function(x) unique(x))


#demographics<- demographics %>% 
#  mutate(age = 
#           age.y %>% 
#           is.na %>%
#           ifelse(age.x, age.y)) %>% 
#  select(-c(age.x, age.y))

# Need to create data set for demographics One line per participant
# demogrpahics_all.csv
# Create subset for Intuition Experiment, Lexical Access and Segmenation Experiment (lab), Segmenation (online)
# intuition_demo.csv, lexical_access_demo.csv, segmentation_lab_demo.csv, segmentation_online_demo.csv
# partID, LexTALE-ENG, LexTale-ESP, Bilingual Langauge Profile
# Store in Box > Intuition > Active > data > attirbutes

#lab_part = read_csv('blp_lextale_lab_participants.csv')
#
## export csv for Miquel Meeting
#write_csv(lang_attitude_clean,'~/Desktop/working_diss_files/r-checking/blp_attitude.csv')
#write_csv(lang_history_clean,'~/Desktop/working_diss_files/r-checking/blp_history.csv')
#write_csv(lang_proficiency_clean,'~/Desktop/working_diss_files/r-checking/blp_proficiency.csv')
#write_csv(lang_use_clean,'~/Desktop/working_diss_files/r-checking/blp_use.csv')
#write_csv(lex_eng_cleaned,'~/Desktop/working_diss_files/r-checking/lextale_english.csv')
#write_csv(lex_esp_cleaned,'~/Desktop/working_diss_files/r-checking/lextale_spanish.csv')
#write_csv(part_scores_demographics,'~/Desktop/working_diss_files/r-checking/participants_informat#ion.csv')
