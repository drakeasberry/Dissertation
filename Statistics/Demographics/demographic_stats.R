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
lex_eng_dir <- 'analyze_data/lextale_eng_cols' #set path to directory

# list all the files with path
lex_eng_files <- list.files(path=lex_eng_dir, 
                            pattern = '*.csv', 
                            full.names = TRUE) 

# read in all the files into one data frame
lex_eng_data <- ldply(lex_eng_files, read_csv)


# Add Group to dataframe
lex_eng_data <- lex_eng_data %>% 
  left_join(group_map, by = 'partNum')

# Remove heritage participants  
lex_eng_no_heritage <- subset(
  lex_eng_data, 
  lex_eng_data$group != 'Childhood')

# Check numbers while debugging
lex_eng_no_heritage %>% 
  group_by(group) %>% 
  summarise(count = n_distinct(partNum)) 

# Select columns to keep without heritage participant data  
lex_eng_data <- lex_eng_no_heritage %>%   
  select("partNum", 
         "group", 
         "word", 
         "translation", 
         "corrAnsEngV", 
         "corrAns", 
         "lextaleRespEng", 
         "lextaleRespEngCorr", 
         "lextaleRespEngRT")

# clean up data
rm(lex_eng_no_heritage, 
   lex_eng_dir, 
   lex_eng_files)


# LexTALE-Spanish Data Directory
lex_esp_dir <- 'analyze_data/lextale_esp_cols' #set path to directory

# list all the files with path
lex_esp_files <- list.files(path=lex_esp_dir, 
                            pattern = '*.csv', 
                            full.names = TRUE) 

# read in all the files into one data frame
lex_esp_data <- ldply(lex_esp_files, read_csv)

# Add Group to table
lex_esp_data <- lex_esp_data %>% 
  left_join(group_map, by = 'partNum')

# Remove heritage participant data
lex_esp_no_heritage <- subset(
  lex_esp_data, 
  lex_esp_data$group != 'Childhood')

# Check numbers while debugging
lex_esp_no_heritage %>% 
  group_by(group) %>% 
  summarise(count = n_distinct(partNum)) 

# Select columns to keep without heritage participant data
lex_esp_data <- lex_esp_no_heritage %>%   
  select("partNum", 
         "group", 
         "word", 
         "translation", 
         "corrAnsEspV", 
         "corrAns", 
         "lextaleRespEsp", 
         "lextaleRespEspCorr", 
         "lextaleRespEspRT")


# clean up data environemnt
rm(lex_esp_no_heritage, 
   lex_esp_dir)


# Basic Langauge Profile Data Directory
blp_dir <- 'analyze_data/blp_cols' #set path to directory

#list all the files with path
blp_files <- list.files(path=blp_dir, 
                        pattern = '*.csv', 
                        full.names = TRUE)

# read in all the files into one data frame
blp_data <- ldply(blp_files, read_csv)

# Add Group to dataframe
blp_data <- blp_data %>% 
  left_join(group_map, by = 'partNum')

# Remove Heritage participant data
blp_no_heritage <- subset(
  blp_data, 
  blp_data$group != 'Childhood')

# Check numbers while debugging
blp_no_heritage %>% 
  group_by(group) %>% 
  summarise(count = n_distinct(partNum)) 

# Select columns to keep without heritage participant data
blp_data <-  blp_no_heritage %>%   
  select("partNum", 
         "group", 
         "sectionEng", 
         "questionTextEng", 
         "languageEng", 
         "langHistResp1",
         "langHistRT1", 
         "langHistResp2", 
         "langHistRT2", 
         "langHistResp", 
         "langHistRT", 
         "langUseResp",
         "langUseRT", 
         "langProfResp", 
         "langProfRT", 
         "langAttResp", 
         "langAttRT")

# remove unnecessary values from Rstudio Environment
rm(blp_no_heritage, 
   blp_dir, 
   blp_files)

# rename column headers
names(blp_data)[names(blp_data)=='sectionEng'] <- 'blp_section'
names(blp_data)[names(blp_data)=='questionTextEng'] <- 'blp_question'
names(blp_data)[names(blp_data)=='languageEng'] <- 'question_language'
names(blp_data)[names(blp_data)=='langHistResp3'] <- 'langHistResp'
names(blp_data)[names(blp_data)=='langHistRT3'] <- 'langHistRT'


# create one column for Language History responses
# create counter variables
i <- 1
j <- 2

while (i<length(blp_data$blp_question))
{
  # copies information from langHistResp1 to langHistResp
  blp_data$langHistResp[i:j] <- blp_data$langHistResp1[i:j] 
  # copies information from langHistRT1 to langHistRT
  blp_data$langHistRT[i:j] <- blp_data$langHistRT1[i:j]
  # increase counter
  i <- i + 2
  j <- j + 2
  # copies information from langHistResp2 to langHistResp
  blp_data$langHistResp[i:j] <- blp_data$langHistResp2[i:j]
  # copies information from langHistRT2 to langHistRT
  blp_data$langHistRT[i:j] <- blp_data$langHistRT2[i:j]
  # increase counters
  i <- i + 41
  j <- j + 41
}

# deletes unnecessary columns
blp_data_cleaned <- select(
  blp_data, 
  -c(langHistResp1, 
     langHistRT1, 
     langHistResp2, 
     langHistRT2))

# deletes practice rows in LexTALE test
lex_eng_cleaned <- lex_eng_data %>%
  subset(word != 'platery') %>%
  subset(word != 'denial') %>%
  subset(word != 'generic')

lex_esp_cleaned <- lex_esp_data %>%
  subset(word != 'pladeno') %>%
  subset(word != 'delantera') %>%
  subset(word != 'garbardina')


# Clean up data environment
rm(lex_eng_data, 
   lex_esp_data, 
   blp_data, 
   i, 
   j)


# Get LexTALE scores
# English LexTALE score
lex_eng_score <- aggregate(
  data=lex_eng_cleaned, 
  lextaleRespEngCorr ~ partNum, 
  FUN='mean')

names(lex_eng_score)[
  names(lex_eng_score) == 'lextaleRespEngCorr'] <- 'lextale_eng_correct'

# Spanish LexTALE score
lex_esp_score <- aggregate(
  data=lex_esp_cleaned, 
  lextaleRespEspCorr ~ partNum, 
  FUN='mean')

names(lex_esp_score)[
  names(lex_esp_score) == 'lextaleRespEspCorr'] <- 'lextale_esp_correct'


# Izura method of calculation Monolinguals
# Get all real words that were answered correctly
esp_real_word <- subset(
  lex_esp_cleaned,
  lex_esp_cleaned$translation != "NW" & 
    lex_esp_cleaned$lextaleRespEspCorr == 1) 

# Get all nonword data
esp_non_word <- subset(
  lex_esp_cleaned,
  lex_esp_cleaned$translation == "NW")

# Sum word response data by participant and rename column
esp_wd_corr <- aggregate(
  data=esp_real_word, 
  lextaleRespEspCorr ~ partNum, 
  FUN='sum')

names(esp_wd_corr)[
  names(esp_wd_corr) == 'lextaleRespEspCorr'] <- 'yes_to_word'

# Sum all incorrect responses to non words by participant
esp_nw_incorr <- aggregate(
  data=esp_non_word, 
  lextaleRespEspCorr ~ partNum, 
  FUN='sum')

# Add column to dataframe to storing number of incorrect responses to nonwords
esp_nw_incorr <- esp_nw_incorr %>% 
  add_column(., 
             yes_to_nonword = 30 - esp_nw_incorr$lextaleRespEspCorr) %>% 
  select(.,-c('lextaleRespEspCorr'))

# Merge real word and non word dataframe into one and store calculated izura score
esp_lex_esp_izura <- merge(esp_wd_corr, 
                           esp_nw_incorr, 
                           by='partNum') %>% 
  add_column(.,
             izura_score = .$yes_to_word - 2 * .$yes_to_nonword)
  
# Write csv file for Izura LexTALE-ESP calculations
write_csv(esp_lex_esp_izura, 'analyze_data/output/izura_scores.csv')


# Clean up data environment
rm(esp_non_word, 
   esp_nw_incorr, 
   esp_real_word, 
   esp_wd_corr, 
   lex_eng_cleaned, 
   lex_esp_cleaned)


# Create dataframe for each blp section
# create language history dataframe
lang_history <- subset(
  blp_data_cleaned, 
  blp_section == 'Language history')

lang_history_clean <- select(
  lang_history, 
  -c(langUseResp, 
     langUseRT, 
     langProfResp, 
     langProfRT,
     langAttResp, 
     langAttRT))

# get language acquisition ages for participants in lab from BLP
lang_acq_age <- lang_history_clean

# get Spanish acquistion age 
esp_acq_age <- lang_acq_age %>% 
  subset(., blp_question == 'At what age did you start learning the following languages?') %>% 
  group_by(partNum, question_language, langHistResp) %>% 
  spread(., question_language, langHistResp) %>% 
  rename(span_acq_age = Spanish, eng_acq_age = English) %>% 
  subset(., !is.na(span_acq_age)) %>% 
  select('partNum', 'span_acq_age')

# get English acquistion age
eng_acq_age <- lang_acq_age %>% 
  subset(., blp_question == 'At what age did you start learning the following languages?') %>% 
  group_by(partNum, question_language, langHistResp) %>% 
  spread(., question_language, langHistResp) %>% 
  rename(span_acq_age = Spanish, eng_acq_age = English) %>% 
  subset(., !is.na(eng_acq_age)) %>% 
  select('partNum', 'eng_acq_age')

# Combine language acquisition ages into one data frame
lang_acq_age <- merge(esp_acq_age, eng_acq_age)


# create language use dataframe
lang_use <- subset(
  blp_data_cleaned, 
  blp_section == 'Language use')

lang_use_clean <- select(
  lang_use, 
  -c(langHistResp, 
     langHistRT, 
     langProfResp, 
     langProfRT,
     langAttResp, 
     langAttRT))

# create language proficiency dataframe
lang_proficiency <- subset(
  blp_data_cleaned, 
  blp_section == 'Language proficiency')

lang_proficiency_clean <- select(
  lang_proficiency, 
  -c(langHistResp, 
     langHistRT, 
     langUseResp, 
     langUseRT,
     langAttResp, 
     langAttRT))

# create language attitude dataframe
lang_attitude <- subset(
  blp_data_cleaned, 
  blp_section == 'Language attitudes')

lang_attitude_clean <- select(
  lang_attitude, 
  -c(langHistResp, 
     langHistRT, 
     langUseResp, 
     langUseRT,
     langProfResp, 
     langProfRT))

# remove raw files imported in Rstudio environment
rm(lang_history,
   lang_use,
   lang_proficiency,
   lang_attitude)

# Create blp score dataframes
# basic language profile history score
blp_history_score <- aggregate(
  data=lang_history_clean, 
  langHistResp ~ partNum + question_language, 
  FUN='sum')

# basic language profile use score
blp_use_score <- aggregate(
  data=lang_use_clean, 
  langUseResp ~ partNum + question_language, 
  FUN='sum')

# basic language profile proficiency score
blp_proficiency_score <- aggregate(
  data=lang_proficiency_clean, 
  langProfResp ~ partNum + question_language, 
  FUN='sum')

# basic language profile attitude score
blp_attitude_score <- aggregate(
  data=lang_attitude_clean, 
  langAttResp ~ partNum + question_language, 
  FUN='sum')

# Global Language Scores from BLP Calculation
# English Scores
# history score and rename column
eng_hist <- 
  blp_history_score[blp_history_score$question_language == 'English',]
names(eng_hist)[names(eng_hist) == 'langHistResp'] <- 'eng_hist_score'
eng_hist <- select(
  eng_hist, 
  -c(question_language))

# use score and rename column
eng_use <- 
  blp_use_score[blp_use_score$question_language == 'English',]
names(eng_use)[names(eng_use) == 'langUseResp'] <- 'eng_use_score'
eng_use <- select(
  eng_use, 
  -c(question_language))

# merge history and use dataframes
english <- merge(eng_hist,
                 eng_use,
                 by='partNum')

# proficiency score and rename column
eng_prof <- 
  blp_proficiency_score[blp_proficiency_score$question_language == 'English',]
names(eng_prof)[names(eng_prof) == 'langProfResp'] <- 'eng_prof_score'
eng_prof <- select(
  eng_prof, 
  -c(question_language))

# add proficiency score to merged dataframe with history and use
english <- merge(english,
                 eng_prof,
                 by='partNum')

# attitude score and rename column
eng_att <- 
  blp_attitude_score[blp_attitude_score$question_language == 'English',]
names(eng_att)[names(eng_att) == 'langAttResp'] <- 'eng_att_score'
eng_att <- select(
  eng_att, 
  -c(question_language))

# add attitude score to merged dataframe with history, use and proficiency
english <- merge(english,
                 eng_att,
                 by='partNum')

# add column with calculation of global score
eng_score <- with(
  english,
  (eng_hist_score*0.454 + 
     eng_use_score*1.09 + 
     eng_prof_score*2.27 + 
     eng_att_score*2.27))

# add English calculated score to dataframe containing individual section scores
english$eng_score <- eng_score


# Spanish scores
# history score and rename column
esp_hist <- 
  blp_history_score[blp_history_score$question_language == 'Spanish',]
names(esp_hist)[names(esp_hist) == 'langHistResp'] <- 'esp_hist_score'
esp_hist <- select(
  esp_hist, 
  -c(question_language))

# use score and rename column
esp_use <- 
  blp_use_score[blp_use_score$question_language == 'Spanish',]
names(esp_use)[names(esp_use) == 'langUseResp'] <- 'esp_use_score'
esp_use <- select(
  esp_use, 
  -c(question_language))

# merge history and use dataframes
spanish <- merge(esp_hist,
                 esp_use,
                 by='partNum')

# proficiency score and rename column
esp_prof <- 
  blp_proficiency_score[blp_proficiency_score$question_language == 'Spanish',]
names(esp_prof)[names(esp_prof) == 'langProfResp'] <- 'esp_prof_score'
esp_prof <- select(
  esp_prof, 
  -c(question_language))

# add proficiency score to merged dataframe with history and use
spanish <- merge(spanish,
                 esp_prof,
                 by='partNum')

# attitude score and rename column
esp_att <- 
  blp_attitude_score[blp_attitude_score$question_language == 'Spanish',]
names(esp_att)[names(esp_att) == 'langAttResp'] <- 'esp_att_score'
esp_att <- select(
  esp_att, 
  -c(question_language))

# add attitude score to merged dataframe with history, use and proficiency
spanish <- merge(spanish,
                 esp_att,
                 by='partNum')

# add column with calculation of global score
esp_score <- with(
  spanish,
  (esp_hist_score*0.454 +
     esp_use_score*1.09 + 
     esp_prof_score*2.27 +
     esp_att_score*2.27))

# add English calculated score to dataframe containing individual section scores
spanish$esp_score <- esp_score

# Merge table with English and Spanish global scores from BLP
global_score <- merge(english, 
                      spanish,  
                      by='partNum')

# check that all values are between 0 and 218
min(global_score$eng_score)
min(global_score$esp_score)
max(global_score$eng_score)
max(global_score$esp_score)


# Get language dominance score
# positive numbers indicate English dominance
# negative numbers indicate Spanish dominance
# near 0 indicates more balanced bilinguals
lang_dom <- with(
  global_score,
  eng_score-esp_score)
global_score$lang_dominance <- lang_dom

# Combine global score, group, lexTALE and izura score into single dataframe
part_score <- merge(global_score, 
                    lex_eng_score, 
                    by='partNum') %>% 
  full_join(., lex_esp_score, by='partNum') %>% 
  left_join(., group_map, by = 'partNum') %>% 
  left_join(., esp_lex_esp_izura, by = 'partNum') %>% 
  left_join(., lang_acq_age, by = 'partNum') %>% 
  select("partNum", 
         "group", 
         everything()) %>% 
  rename(global_eng_score = eng_score, 
         global_esp_score = esp_score, 
         izura_yes_to_words = yes_to_word, 
         izura_yes_to_nonwords = yes_to_nonword)


# Clean up data environment
rm(eng_score,
   esp_score,
   lang_dom, 
   blp_data_cleaned,
   blp_attitude_score,
   blp_history_score,
   blp_proficiency_score,
   blp_use_score, 
   eng_att,
   eng_hist,
   eng_prof,
   eng_use,
   esp_att,
   esp_hist,
   esp_prof,
   esp_use, 
   english, 
   spanish, 
   lex_esp_score, 
   lex_eng_score, 
   lang_attitude_clean, 
   lang_history_clean, 
   lang_proficiency_clean, 
   lang_use_clean, 
   esp_lex_esp_izura, 
   global_score, 
   group_map, 
   eng_acq_age, 
   esp_acq_age, 
   lang_acq_age)


# Add additional demographic data from Prolific
L2_demo <- read_csv('analyze_data/L2_demographics.csv')
mono_demo <- read_csv('analyze_data/monolingual_demographics.csv') %>% 
  add_column("Fluent languages" = NA) %>% 
  add_column("Were you raised monolingual?" = NA)
online_demo <- rbind(L2_demo,
                     mono_demo)

rm(mono_demo, 
   L2_demo)

# Additional demogrpahic data from PsychoPy
# read in all the files into one data frame
demographics <- ldply(lex_esp_files, read_csv)
demographics <- demographics %>% 
  select(c("partNum":"expName", 
           "raisedCountry":"last_class")) %>% 
  left_join(online_demo, by = 'partNum') %>%
  left_join(part_score, by = 'partNum') %>% 
  distinct()

# Create file with all participants and demographic information
# Translate all Spanish into English
# Prepare data for figures and tables later
all_participants <- demographics %>%
  subset(., !is.na(group)) %>% 
  rename(birth_country = `Country of Birth`, 
         acquisition_age = first_learning,
         employed = `Employment Status`, 
         native_lang = `First Language`,
         fluent_lang = `Fluent languages`, 
         student = `Student Status`,
         raised_monolingual = `Were you raised monolingual?`) %>% 
  mutate(age = ifelse(
    is.na(age.y), 
    age.x, 
    age.y),
    current_residence = ifelse(
      is.na(`Current Country of Residence`), 
      placeResidence, 
      `Current Country of Residence`),
    current_residence = ifelse(
      current_residence == "Estados Unidos", 
      "United States",
      current_residence),
    preferLanguage = ifelse(
      preferLanguage == 'inglés', 
      'English', 
      preferLanguage),
    preferLanguage = ifelse(
      preferLanguage == 'español', 
      'Spanish', 
      preferLanguage),
    houseLanguage = ifelse(
      houseLanguage == 'inglés', 
      'English', 
      houseLanguage),
    houseLanguage = ifelse(
      houseLanguage == 'español', 
      'Spanish', 
      houseLanguage),
    houseLanguage = ifelse(
      houseLanguage == 'ambos', 
      'Both', 
      houseLanguage),
    Bilingual = ifelse(
      Bilingual == 'I know one other language in addition to English',
      'native language + one other language', 
      Bilingual),
    Bilingual = ifelse(
      Bilingual == 'Not Used',  
      'native language + one other language', 
      Bilingual),
    acquisition_age = ifelse(
      acquisition_age == 'seis', 
      6, 
      acquisition_age),
    acquisition_age = ifelse(
      acquisition_age == 'A los 12 años de edad', 
      12, 
      acquisition_age),
    acquisition_age = ifelse(
      acquisition_age == 'a los 5 anos', 
      5, 
      acquisition_age),
    acquisition_age = ifelse(
      acquisition_age == 'con mi esposo', 
      NA, 
      acquisition_age),
    span_acq_age = ifelse(
      is.na(span_acq_age), 
      acquisition_age, 
      span_acq_age),
    span_acq_age = ifelse(
      group == 'Monolingual Spanish', 
      0, 
      span_acq_age),
    speaking = ifelse(
      speaking == 'principiante', 
      'Beginner', 
      speaking),
    speaking = ifelse(
      speaking == 'intermedio', 
      'Intermediate',  
      speaking),
    speaking = ifelse(
      speaking == 'intermediate', 
      'Intermediate',  
      speaking),
    speaking = ifelse(
      speaking == 'avanzado', 
      'Advanced', 
      speaking),
    speaking = ifelse(
      speaking == 'superior',
      'Superior',
      speaking),
    speaking = ifelse(
      speaking == 'nativo bilingüe',
      'Native-like',
      speaking),
    listening = ifelse(
      listening == 'principiante', 
      'Beginner', 
      listening),
    listening = ifelse(
      listening == 'intermedio', 
      'Intermediate',  
      listening),
    listening = ifelse(
      listening == 'intermediate',
      'Intermediate',  
      listening),
    listening = ifelse(
      listening == 'avanzado', 
      'Advanced', 
      listening),
    listening = ifelse(
      listening == 'superior',
      'Superior', 
      listening),
    listening = ifelse(
      listening == 'nativo bilingüe',
      'Native-like', 
      listening),
    reading = ifelse(
      reading == 'principiante', 
      'Beginner', 
      reading),
    reading = ifelse(
      reading == 'intermedio', 
      'Intermediate',  
      reading),
    reading = ifelse(
      reading == 'intermediate', 
      'Intermediate',  
      reading),
    reading = ifelse(
      reading == 'avanzado', 
      'Advanced',
      reading),
    reading = ifelse(
      reading == 'superior', 
      'Superior', 
      reading),
    reading = ifelse(
      reading == 'nativo bilingüe', 
      'Native-like', 
      reading),
    writing = ifelse(
      writing == 'principiante', 
      'Beginner', 
      writing),
    writing = ifelse(
      writing == 'intermedio', 
      'Intermediate',  
      writing),
    writing = ifelse(
      writing == 'intermediate', 
      'Intermediate',  
      writing),
    writing = ifelse(
      writing == 'avanzado', 
      'Advanced', 
      writing),
    writing = ifelse(
      writing == 'superior', 
      'Superior', 
      writing),
    writing = ifelse(
      writing == 'nativo bilingüe',
      'Native-like', 
      writing),
    last_class = ifelse(
      last_class == 'durante el último año',
      'During the last year', 
      last_class),
    last_class = ifelse(
      last_class == 'hace un año',
      '1 year ago', 
      last_class),
    last_class = ifelse(
      last_class == 'a year ago',
      '1 year ago', 
      last_class),
    last_class = ifelse(
      last_class == 'hace dos años', 
      '2 years ago', 
      last_class),
    last_class = ifelse(
      last_class == 'hace tres años', 
      '3 years ago', 
      last_class),
    last_class = ifelse(
      last_class == 'hace cuatro o más años', 
      '4+ years ago', 
      last_class),
    fluent_lang = ifelse(
      fluent_lang == 'Spanish, English', 
      'English, Spanish', 
      fluent_lang),
    education = ifelse(
      education == "Escuela Secundaria", 
      "High School", 
      education),
    education = ifelse(
      education == "Un poco de universidad", 
      "Some College", 
      education),
    education = ifelse(
      education == "University (diploma, bachelor's degree)", 
      "Bachelor Degree", 
      education),
    education = ifelse(
      education == "Universidad (diplomatura, licenciatura)", 
      "Bachelor Degree", 
      education),
    education = ifelse(
      education == "Un poco de escuela graduada", 
      "Some Graduate Courses", 
      education),
    education = ifelse(
      education == "Máster", 
      "Master Degree", 
      education),
    education = ifelse(
      education == "Doctorado", 
      "Doctorate Degree", 
      education),
    raisedCountry = ifelse(
      raisedCountry == 'Estados Unidos', 
      "US", 
      raisedCountry),
    raisedCountry = ifelse(
      raisedCountry == 'U.S',
      "US",
      raisedCountry),
    raisedCountry = ifelse(
      raisedCountry == 'México',
      "MX", 
      raisedCountry),
    gender = ifelse(
      gender == 'Mujer', 
      'Female', 
      gender),
    gender = ifelse(
      gender == 'Woman', 
      'Female', 
      gender),
    gender = ifelse(
      gender == 'Hombre',
      'Male', 
      gender),
    birth_country = ifelse(
      is.na(birth_country), 
      birthCountry, 
      birth_country),
    birth_country = ifelse(
      birth_country == 'United States' | birth_country == 'Estados Unidos',
      'US', 
      birth_country),
    birth_country = ifelse(
      birth_country == 'Mexico' | birth_country == 'México',
      'MX', 
      birth_country),
    lextale_eng_correct = lextale_eng_correct * 100,
    lextale_esp_correct = lextale_esp_correct * 100,
    vocab_diff = lextale_eng_correct - lextale_esp_correct) %>%
  select(c('partNum', 
           'group', 
           'gender', 
           'age', 
           'speaking':'last_class', 
           'native_lang', 
           'houseLanguage', 
           'fluent_lang', 
           'education', 
           'Bilingual', 
           'Nationality', 
           'birth_country', 
           'raisedCountry', 
           'current_residence',
           'eng_hist_score':'lextale_esp_correct',
           'vocab_diff',
           'izura_yes_to_words':'eng_acq_age', 
           'placeResidence', 
           'expName'))

glimpse(all_participants)
write_csv(all_participants, 
          'analyze_data/output/all_participant_demo.csv')

# clean up data environment
rm(online_demo, 
   part_score,
   lex_esp_files)

# gives a checkpoint to start from if no data has been changed
# uncomment next line to use read_csv()
#all_participants <- read_csv('analyze_data/output/all_participant_demo.csv')
demographics <- all_participants

# Outliers in Language Dominance Test
# English group outlier test
english_outlier_dom <- demographics %>% 
  subset(., lang_dominance < 50 & group == 'English') # part007

# Spanish group outlier test
spanish_outlier_dom <- demographics %>% 
  subset(., lang_dominance > 0 & group == 'Spanish') # part031 & part058


# Test to ensure L1 vocabulary is larger than L2 vocabulary
eng_higher_L2_vocab <- demographics %>% 
  subset(., lextale_eng_correct < lextale_esp_correct & 
           group == 'English') %>% 
  ## No one removed
  select(c('partNum',
           'gender':'placeResidence', 
           'group', 
           'lang_dominance':'lextale_esp_correct')) 

esp_higher_L2_vocab <- demographics %>% 
  subset(., lextale_eng_correct > lextale_esp_correct & group == 'Spanish') %>% 
  ## part033 86 Eng 68 SP, part016 76 Eng 74 SP, part059 78 Eng 73 SP
  select(c('partNum',
           'gender':'placeResidence', 
           'group', 
           'lang_dominance':'lextale_esp_correct')) 


# Check to ensure participant group identifications match
# Spanish group not born in Mexico
esp_wrong_demo <- demographics %>% 
  subset(., birth_country == 'US' & group == 'Spanish') 
## part027, part052

# English group not born in US
eng_wrong_demo <- demographics %>% 
  subset(., birth_country == 'MX' & group == 'English') 
## no one removed


# Clean up environment
rm(esp_wrong_demo, 
   eng_wrong_demo, 
   eng_higher_L2_vocab, 
   english_outlier_dom, 
   esp_higher_L2_vocab,
   spanish_outlier_dom,
   all_participants)


# all demographic information for lab segmentation experiment
lab_segmentation <- 
  subset(demographics, expName == 'Segmentation') %>% 
  select_if(~!all(is.na(.))) %>% 
  subset(., group != 'Childhood') %>%
  select(-c('expName')) %>% 
  select(c('partNum',
           'group',
           'age',
           'span_acq_age',
           'eng_acq_age',
           'gender',
           'birth_country',
           'current_residence',
           'education',
           'eng_hist_score':'izura_score'))


# subset English group in lab segmentation experiment
eng <- lab_segmentation %>%
  subset(., group == 'English') %>% 
  mutate(odd_dir = ifelse(
    vocab_diff > 0, 
    'keep', 
    'delete')) %>% 
  select('partNum', 
         'group', 
         'vocab_diff', 
         'odd_dir')


# subset Spanish group in lab segmentation experiment
esp <- lab_segmentation %>%
  subset(., group == 'Spanish') %>% 
  mutate(odd_dir = ifelse(
    vocab_diff < 0, 
    'keep', 
    'delete')) %>% 
  select('partNum', 
         'group', 
         'vocab_diff', 
         'odd_dir')

# Combine English and Spanish groups in lab segmentation experiment
vocab_diff_segmenation <- rbind(eng, esp)
## L1 English is positive and L1 Spanish = negative indicating larger L1 vocabulary

# Write out file for visualization
write_csv(vocab_diff_segmenation, 
          'analyze_data/output/lab_vocab_sizes.csv')

# Write statement for file containing only necessary columns for lab segmentation analysis
write_csv(
  lab_segmentation, 
  '../Segmentation/analyze_data/demographics/46_lab_segmentation.csv')
# For PI Advisor
#write_csv(lab_segmentation, '../Segmentation/analyze_data/demographics/attributes.csv')

# Clean up environment
rm(eng, 
   esp)

# Create table for all demographic information for participants only in lab Lexical access experiment
lab_lexical_only <- 
  subset(demographics, expName == 'Lexical_Access') %>% 
  select_if(~!all(is.na(.))) %>% 
  subset(., group != 'Childhood') %>% 
  select(-c('expName')) %>% 
  select(c('partNum',
           'group',
           'age',
           'span_acq_age',
           'eng_acq_age',
           'gender',
           'birth_country',
           'current_residence',
           'education',
           'eng_hist_score':'izura_score')) 


# subset English group that gave syllable intuition data during Lab Lexical Access Experiment
eng <- lab_lexical_only %>%
  subset(., group == 'English') %>% 
  mutate(odd_dir = ifelse(
    vocab_diff > 0, 
    'keep', 
    'delete')) %>% 
  select('partNum', 
         'group', 
         'vocab_diff', 
         'odd_dir')

# subset Spanish group that gave syllable intuition data during Lab Lexical Access Experiment
esp <- lab_lexical_only %>%
  subset(., group == 'Spanish') %>% 
  mutate(odd_dir = ifelse(
    vocab_diff < 0, 
    'keep', 
    'delete')) %>% 
  select('partNum', 
         'group', 
         'vocab_diff', 
         'odd_dir')

# Combine English and Spanish groups who gave syllable intuition data during Lab Lexical Access Experiment
vocab_diff_lexical_only <- rbind(eng, esp)


# Clean up environment
rm(eng, 
   esp)


# Write statement for file containing only necessary columns for lab lexical access only analysis
write_csv(
  lab_lexical_only, 
  '../Lexical_Access/analyze_data/demographics/21_lab_2nd_exp_only.csv')
# For PI Advisor
#write_csv(lab_lexical_only, '../Lexical_Access/analyze_data/demographics/2nd_exp_only_attributes.csv')


# Read in all lexical participants including those who returned for second iteration
all_lexical_part <- 
  read_csv('../Lexical_Access/analyze_data/output/42_lexical_access.csv')

# Create table for all demographic information in lab Lexical access experiment
lab_lexical <- subset(
  demographics, 
  expName != 'lemma_segmentation' & 
    partNum %in% all_lexical_part$partNum) %>%
  select_if(~!all(is.na(.))) %>% 
  subset(., group != 'Childhood') %>% 
  select(-c('expName')) %>% 
  select(c('partNum',
           'group',
           'age',
           'span_acq_age',
           'eng_acq_age',
           'gender',
           'birth_country',
           'current_residence',
           'education',
           'eng_hist_score':'izura_score'))


# subset English group in lab lexical experiment
eng <- lab_lexical %>%
  subset(., group == 'English') %>% 
  mutate(odd_dir = ifelse(
    vocab_diff > 0,
    'keep',
    'delete')) %>% 
  select('partNum', 
         'group', 
         'vocab_diff', 
         'odd_dir')


# subset Spanish group in lab lexical experiment
esp <- lab_lexical %>%
  subset(., group == 'Spanish') %>% 
  mutate(odd_dir = ifelse(
    vocab_diff < 0, 
    'keep', 
    'delete')) %>% 
  select('partNum', 
         'group', 
         'vocab_diff',
         'odd_dir')


# Combine English and Spanish groups in lab segmentation experiment
vocab_diff_lexical <- rbind(eng, esp)
## L1 English is positive and L1 Spanish = negative indicating larger L1 vocabulary


# Write out file for visualization
write_csv(
  vocab_diff_lexical, 
  'analyze_data/output/lab_lex_vocab_sizes.csv')


# Write statement for file containing only necessary columns for lab lexical access only analysis
write_csv(
  lab_lexical, 
  '../Lexical_Access/analyze_data/demographics/42_lab_lexical.csv')
# For PI Advisor
#write_csv(lab_lexical, '../Lexical_Access/analyze_data/demographics/attributes.csv')

# Clean up environment
rm(eng, 
   esp, 
   all_lexical_part, 
   vocab_diff_lexical,
   lab_lexical) # removed because not part of diss anymore


# Combine segmenatation and lexical access dataframes for intuition experiment
vocab_diff_intuition <- 
  rbind(vocab_diff_segmenation, vocab_diff_lexical_only)

# Write out file for visualization
write_csv(
  vocab_diff_intuition, 
  'analyze_data/output/intuition_vocab_sizes.csv')


# Create table for all demographic information for participants in intuition experiment  
lab_intuition <- subset(
  demographics, 
  expName != 'lemma_segmentation') %>%
  select_if(~!all(is.na(.))) %>% 
  subset(., group != 'Childhood') %>%
  subset(., partNum %in% vocab_diff_intuition$partNum) %>% 
  select(c('partNum',
           'group',
           'age',
           'span_acq_age',
           'eng_acq_age',
           'gender',
           'birth_country',
           'current_residence',
           'education',
           'eng_hist_score':'izura_score'))

# Write statement for file containing only necessary columns for lab intuition analysis
write_csv(
  lab_intuition, 
  '../Intuition/analyze_data/demographics/67_lab_intuition.csv')
# For PI Advisor naming convention in secure cloud storage
#write_csv(lab_intuition, '../Intuition/analyze_data/demographics/attributes.csv')

# Clean up environment
rm(vocab_diff_intuition, 
   vocab_diff_lexical_only, 
   vocab_diff_segmenation)


online_lemma <- subset(
  demographics, 
  expName == 'lemma_segmentation') %>% 
  select(c('partNum', 
           'group':'current_residence', 
           'lextale_esp_correct',
           'izura_yes_to_words':'span_acq_age'))
             
sapply(online_lemma,function(x) unique(x))

# Create subsets for participant groups 
natives <- subset(online_lemma, group == 'Monolingual Spanish')
learners <- subset(online_lemma, group == 'L2 Learner')


# Write out csv file with names
write_csv(
  natives, 
  '../Monolingual_lemma/analyze_data/demographics/49_natives.csv')
write_csv(
  learners, 
  '../L2_lemma/analyze_data/demographics/70_learners.csv')
write_csv(
  online_lemma, 
  'analyze_data/output/online_demo_data.csv')
# Write csv files for PI Advisor
#write_csv(natives, '../Monolingual_lemma/analyze_data/demographics/attributes.csv')
#write_csv(learners, '../L2_lemma/analyze_data/demographics/attributes.csv')
