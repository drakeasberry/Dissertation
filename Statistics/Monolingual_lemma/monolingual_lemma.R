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

# Individual file test
#file01 <- read_csv("analyze_data/raw/5c53e9b6b7cf140001d31e6a_lemma_segmentation_2020-07-09_13h38.38.934_seg_cols.csv")
#file01_exp <- drop_na(file01, any_of("corrAns"))

# Load all files 
seg_files <- list.files(path='analyze_data/raw/', pattern = '*.csv', full.names = TRUE) #list all the files with path
df_raw_seg <- ldply(seg_files, read_csv)
#write_csv(df_raw_seg,'all_50_mono_lemma_raw.csv')

# Delete practice trial rows
file_exp <- drop_na(df_raw_seg, any_of("corrAns"))

# write out all observations in segementation experiment
#write_csv(file_exp, 'all_50_participants_monolingual_all_lemma.csv')

# Checking Data Demographics
unique(file_exp$birthCountry)
unique(file_exp$raisedCountry)
unique(file_exp$placeResidence)
unique(file_exp$houseLanguage)
unique(file_exp$preferLanguage)
unique(file_exp$OS)

raised_country <- file_exp[ which(file_exp$raisedCountry =='Estados Unidos'),]
unique(raised_country$partNum)

house_lang <- file_exp[ which(file_exp$houseLanguage!='español'),]
unique(house_lang$partNum)

prefer_lang <- file_exp[ which(file_exp$preferLanguage!='español'),]
unique(prefer_lang$partNum)

# Check accuracy (95% is probably a decent cut off since they can acieve 90% by not responding at all)
aggregate(file_exp[, c('segRespCorr')], list(file_exp$partNum), mean)

# Participant exclusions
# Kept
# part206 included because only had basic university English requirements
# part214 included because only had basic English requirements (basic A2 on CEFR)

# Dropped
# part205 dropped because their level of English could not be verified
# part221 dropped because of low score (< 10) on LexTALE-ESP
# part226 dropped because they reported being raised in US and having an avanced level of English
# part251 dropped because they reported being raised in US and having an avanced level of English
# part252 dropped because of low score (< 10) on LexTALE-ESP


#drop_list <- c("part205","part221","part226", "part251", "part252")
#
## drop participants who should not be analyzed
#drop_participants <- subset(file_exp, file_exp$partNum %ni% drop_list)
#write_csv(drop_participants, 'all_50_eligible_mono_all_segmenation_responses.csv')

# Need library 'tidyverse' loaded
# Create subset of all critical items
#print('Counts of responses to critical items')
#print('1 = response and None = no response')
seg_critical <- file_exp %>% 
  subset(., fillerCarrier == 'critical')
#Prints tibble showing all responses and frequency of response to critical items
#count(seg_critical, vars=segResp)
#write_csv(seg_critical,'mono_50_critical_items_lemma.csv')

# Further subset critical data set to those that were NOT responded to by participants
seg_critical_misses <- subset(seg_critical, seg_critical$segRespCorr == 0)
#write_csv(seg_critical_misses,'critical_misses_lemma.csv')

# Further subset critical data set to those that were NOT responded to by participants
seg_critical_hits <- subset(seg_critical, seg_critical$segRespCorr == 1)
#write_csv(seg_critical_hits,'critical_hits_lemma.csv')

# Create a tibble of participants who incorrectly did not respond to critical item including number of errors
df_seg_critical_errors <- count(seg_critical_misses, vars=partNum)
print('Counts of responses to critical items by participant')
print(as_tibble(df_seg_critical_errors), n=100) # n default is 10, but here it has been changed to 100 viewable rows

# Check for outliers accuracy
#percent_correct <- aggregate(seg_critical$segRespCorr, by= list(seg_critical$partNum), FUN=mean)
#histogram(~x, percent_correct)
#with(percent_correct, bwplot(x~Group.1))
#with(percent_correct, bwplot(x))

# Create a subset of all filler items
seg_filler <- file_exp %>% 
  subset(., fillerCarrier != 'critical')

#print('Counts of responses to filler items')
#print('1 = response and None = no response')
# Prints tibble showing all responses and frequency of response to filler items
#count(seg_filler, vars=segResp)
#write_csv(seg_filler,'mono_50_filler_items_lemma.csv')

# Further subset filler data set to those that were responded to by participants
seg_filler_responses <- subset(seg_filler, seg_filler$segRespCorr == 0)
#write_csv(seg_filler_responses,'filler_responses_lemma.csv')

# Create a dataframe of participants who incorrectly responded to a filler item
df_seg_filler_errors <- count(seg_filler_responses, vars=partNum)
#print('Counts of responses to filler items by participant')
print(as_tibble(df_seg_filler_errors), n=100) # n default is 10, but here it has been changed to 100 viewable rows

# Find all participants who responded 57 or more times (>=10%) to filler items
# or missed more than 6 critical item (>= 10%), and they will be used to index later
high_seg_filler_responses <- c(which(df_seg_filler_errors$n >= 57.6))
high_seg_filler_responses #prints row numbers on filler data points excedding 43
high_miss_seg_critical_responses <- c(which(df_seg_critical_errors$n >= 6.4))
high_miss_seg_critical_responses #prints row numbers on critical data points excedding 5
high_miss_seg_critical_users <- subset(df_seg_critical_errors, df_seg_critical_errors$n >=6.4)
names(high_miss_seg_critical_users)[names(high_miss_seg_critical_users)=='vars'] <- 'partNum' 
write_csv(high_miss_seg_critical_users, '../Demographics/analyze_data/natives_high_error_rates')
# Create new tibbles based only on participants who committed a high number errors to fillers
tb_high_seg_filler_error_part <- df_seg_filler_errors[high_seg_filler_responses,] # creates tibble of participants and number of errors
#tb_high_seg_filler_error_part #prints 2 column tibble of participant and error rate
tb_high_seg_critical_error_part <- df_seg_critical_errors[high_miss_seg_critical_responses,] # creates tibble of participants and number of errors
#tb_high_seg_critical_error_part #prints 2 column tibble of participant and error rate

# Creates subset of wrong answers committed by high error rate participants
df_high_seg_errors_part <- seg_filler_responses[seg_filler_responses$partNum %in% tb_high_seg_filler_error_part$vars,]
#df_high_seg_errors_part

# Creates subset of wrong answers commited by low error rate participants
df_low_seg_errors_part <- seg_filler_responses[seg_filler_responses$partNum %ni% tb_high_seg_filler_error_part$vars,]
#df_low_seg_errors_part

# looks for too quick of response, anything below 200 ms
button_held_high <- c(which(df_high_seg_errors_part$segRespRT < .200))
#print('prints responses given below 200ms')
#button_held_high
tech_error_high <- df_high_seg_errors_part[button_held_high,c('partNum','segRespRT')]
#print('prints responses given below 200ms by participant number')
#tech_error_high
#length(tech_error_high$segRespRT)

button_not_held_high <- c(which(df_high_seg_errors_part$segRespRT >= .200))
#length(button_not_held_high)

# Same as above but for low error committing participants
button_held_low <- c(which(df_low_seg_errors_part$segRespRT < .200))
#button_held_low
tech_error_low <- df_low_seg_errors_part[button_held_low,c('partNum','segRespRT')]
button_not_held_low <- c(which(df_low_seg_errors_part$segRespRT >= .200))

# Combine tibbles into new tibble
tb_tech_part_error <- full_join(count(tech_error_high, vars=partNum), count(df_high_seg_errors_part, vars=partNum), by = 'vars', copy = FALSE, suffix = c("_tech_errors", "_total_errors"))

# Add a column to new tibble with difference calculated to see real number of errors
# This shows the number of errors committed by participant NOT due to technical issues
tb_tech_error_removed <- add_column(tb_tech_part_error,non_technical_errors=tb_tech_part_error$n_total_errors - tb_tech_part_error$n_tech_errors,.after = 'n_total_errors')

# Test to see if any participant has still committed more than 10% error rate to filler items
# If investigate has participants, they need to be removed for higher error rates,
# If investigate is empty, this is a positive.
investigate <- c(which(tb_tech_error_removed$non_technical_errors > 57))
if(length(investigate) == 0){
  print('No issues here')
  rm(df_high_seg_errors_part,df_low_seg_errors_part, tb_high_seg_critical_error_part,
     tb_high_seg_filler_error_part,tb_tech_error_removed,tb_tech_part_error,
     tech_error_high,tech_error_low, button_held_high, button_held_low,
     button_not_held_high, button_not_held_low, high_miss_seg_critical_responses, 
     high_seg_filler_responses, df_seg_critical_errors, df_seg_filler_errors, investigate)
} else{
  print('See who has too many errors:')
}

rm(df_low_seg_errors_part,df_high_seg_errors_part,df_seg_filler_errors,df_seg_critical_errors
   ,file_exp, new_data,seg_files,seg_filler,seg_filler_responses,df_raw_seg)

#preseve original dataframe
seg_critical_raw <- seg_critical

# start plotting
# Looking at Response Times
seg_critical <- seg_critical_hits %>%
  #left_join(.,calc_seg_part,by='partNum') %>% # Join reported group classification
  mutate(segRespRT = round(segRespRT * 1000, 2),
         log_RT = log(segRespRT)) %>% # convert seconds to milliseconds, create log rt column
  select('partNum','block': 'log_RT', 'age':'preferLanguage','date':'session') %>% # reorder columns
  subset(.,fillerCarrier == 'critical' & segRespCorr == 1) %>% # get only critical items repsonses
  subset(.,segRespRT >= 200 & segRespRT <= 1500) %>% # remove repsonse below 200ms
  subset(.,partNum %ni% high_miss_seg_critical_users$vars)

valid_part <- unique(seg_critical$partNum)
#saveRDS(valid_part, file="../Demographics/mono_lemma_participants")

# Write a csv file with valid data points for participants who meet inclusion criteria
write_csv(seg_critical, '44_monolingual_valid_response_critical_items.csv')

# Create subset with only participant responses who meet inclusion criteria
participant_responses_all <- subset(drop_participants, drop_participants$partNum %in% valid_part)
write_csv(participant_responses_all, '44_monolingual_all_segmentation_responses.csv')

# Run to here to check data validation participants provided good data 

segmentation_data <- participant_responses_all %>% 
  subset(., fillerCarrier == 'critical' & segResp == 'b') %>% # 100 critical errors removed
  mutate(segRespRTmsec = round(segRespRT * 1000),
         log_RT = log(segRespRT)) %>%
  subset(., segRespRTmsec > 200) %>% # removed 1 point
  subset(., segRespRTmsec < 1500) %>% # removed 47 points
  rename(segRespRTsec = segRespRT, word = expWord, word_status = wd_status,
         word_initial_syl = wd_int_syl_str, target_syl_structure = tar_syl_str,
         targetSyl = tar_syl, word_initial_3_letters = first_3) %>% 
  select("partNum","segRespRTsec", "segRespRTmsec", "log_RT", "lemma", "word", 
         "word_initial_3_letters", "word_status","word_initial_syl", "targetSyl", 
         "target_syl_structure","matching", "block")

# Check to ensure no column only contains one unique value
segmentation_data %>% 
  summarise_all(n_distinct)

# Check minimum and maximum reaction times 
segmentation_data %>% 
  summarise_at(vars(segRespRTmsec),list(quickest = min, slowest = max))

# For PI Advisor
write_csv(segmentation_data, 'natives.csv')

#participants <- unique(select(seg_critical,c(partNum,session,preferLanguage)))
#rand_subset <- c('part009','part081','part091','part035','part022','part058','part112','part079','part033','part024')
#replicate <- subset(seg_critical,partNum == 'part009'|partNum == 'part081'|partNum == 'part091'|partNum == 'part035'|partNum == 'part022'|partNum == 'part058'|partNum == 'part112')
#replicate <- subset(seg_critical, partNum %in% rand_subset == TRUE)
#part <- unique(select(replicate,c(partNum,session,preferLanguage)))
#mean <- tapply(replicate$segRespRT, replicate$partNum, FUN = mean)
#minimum <- tapply(replicate$segRespRT, replicate$partNum, FUN = min)
#maximum <- tapply(replicate$segRespRT, replicate$partNum, FUN = max)
#df_2 <- tibble(partNum =part$partNum, scriptMean = mean, scriptMin = minimum, scriptMax = maximum)
#subset_df <- merge(part,df_2)
#write_csv(subset_df,'script_test_values.csv')
#write_csv(test,'script_cond_test_values.csv')
#subset(.,word != 'permsio') %>% # experiment error (typo made it a nonword)
#  subset(.,word != 'permiso') %>% # removed counterpart to typo above (May not be necessary ASK)
#  subset(.,partNum %in% unique(calc_seg_part$partNum)) # subset to only remaining participants

summary(seg_critical)

densityplot(~segRespRT, data = seg_critical, main = ' Segmentation Reaction Time in Milliseconds') 
stripplot(~segRespRT, data = seg_critical, main = ' Segmentation Reaction Time in Milliseconds') 
densityplot(~log_RT, data = seg_critical, main = 'Segmentation Reaction as Log') 

# Monolingual Reaction Times Plots
with(seg_critical, bwplot(log_RT~wd_int_syl_str|tar_syl_str, main = 'log RT for Target Syllable Structure', xlab = 'Word Initial Syllable Structure'))
with(seg_critical, bwplot(log_RT~wd_int_syl_str|tar_syl, main = 'log RT for Target Syllables', xlab = 'Word Initial Syllable Structure'))
with(seg_critical, bwplot(segRespRT~wd_int_syl_str, main = 'RT (msec) for Word Intitial Syllable Structure', xlab = 'Word Initial Syllable Structure'))
with(seg_critical, bwplot(segRespRT~tar_syl_str, main = 'RT (msec) for Target Syllable Structure', xlab = 'Target Syllable Structure'))

# Monolingual Reaction Times Tables
# rows are syllable structure type of target
# columns are syllable structure of initial word syllable
tapply(seg_critical$segRespRT, list(seg_critical$tar_syl_str,seg_critical$matching,seg_critical$partNum), FUN = mean)
#tapply(seg_critical$segRespRT, list(seg_critical$tar_syl,seg_critical$matching,seg_critical$partNum), FUN = mean)
#tapply(seg_critical$segRespRT, list(seg_critical$target_syl_structure,seg_critical$matching,seg_critical$partGroup), FUN = min)
#Spanish Only
#esp <- subset(seg_critical, partGroup == 'Spanish')
with(seg_critical, bwplot(segRespRT~wd_int_syl_str|tar_syl_str, main = 'RT (msec) by Target Syllable Structure', xlab = 'Word Initial Syllable Structure'))
#df <- tibble(tapply(esp$segRespRT, list(esp$target_syl_structure,esp$matching,esp$partNum), FUN = mean))

#(scale function) mean - token / stdev (zscoring) 
# package(standardize)
ag_all <- aggregate(seg_critical$segRespRT, by = list(seg_critical$partNum,seg_critical$matching,seg_critical$tar_syl_str), FUN = mean)
cv_match_all <- subset(ag_all,Group.2 == 'match' & Group.3 == 'CV')
cvc_match_all <- subset(ag_all,Group.2 == 'match' & Group.3 == 'CVC')
cv_mismatch_all <- subset(ag_all,Group.2 == 'mismatch' & Group.3 == 'CV')
cvc_mismatch_all <- subset(ag_all,Group.2 == 'mismatch' & Group.3 == 'CVC')

averaged_all <- ag_all
averaged_all <- ag_all %>%
  add_column(int_wd_syl = ifelse(averaged_all$Group.2 == 'match',averaged_all$Group.3,
                                 ifelse(averaged_all$Group.2 != 'match' & averaged_all$Group.3 == 'CV','CVC','CV')))
names(averaged_all) <- c('participant','int_syl_structure_match','target_syl','rt_ms','int_wd_syl')

cvTargets_all <- subset(averaged_all,target_syl == 'CV')
cvcTargets_all <- subset(averaged_all,target_syl == 'CVC')
cvCarrier_all <- subset(averaged_all,int_wd_syl == 'CV')
cvcCarrier_all <- subset(averaged_all,int_wd_syl == 'CVC')
#t.testing
t.test(cvTargets_all$rt_ms~cvTargets_all$int_wd_syl)
t.test(cvcTargets_all$rt_ms~cvcTargets_all$int_wd_syl)
t.test(cvCarrier_all$rt_ms~cvCarrier_all$target_syl)
t.test(cvcCarrier_all$rt_ms~cvcCarrier_all$target_syl)

mydata_all <- averaged_all %>%
  group_by(target_syl,int_wd_syl) %>%
  summarise(average = mean(rt_ms))

#Crossover plots
ggplot(data=mydata_all,aes(x=target_syl,y=average, group=int_wd_syl, color=int_wd_syl)) +
  geom_line() + 
  geom_point() + 
  labs(title="RTs by Target and Carrier Item Syllable Structure Pooled",x="Target Structure",y= "Reaction Time (msec)")



#df_cv <- full_join(cv_match,cv_mismatch, by = 'Group.1')
#df_cvc <- full_join(cvc_match,cvc_mismatch, by = 'Group.1')
#df <- merge(df_cv,df_cvc, by.x = 'Group.1', by.y = 'Group.1')
#names(df) <- c("part", "cv_matching", "cv_matching_str", "cv_matching_rt", "cv_mis", "cv_mis_str", "cv_mis_rt", "cvc_matching", "cvc_matching_str", "cvc_matching_rt", "cvc_mis", "cvc_mis_str", "cvc_mis_rt")
#
#
#df_cv_expected <- subset(df, cv_matching_rt < cv_mis_rt)
#df_cv_odd <- subset(df, cv_matching_rt > cv_mis_rt)
#df_cvc_expected <- subset(df, cvc_matching_rt < cvc_mis_rt)
#df_cvc_odd <- subset(df, cvc_matching_rt > cvc_mis_rt)
#
#overlap <- merge(df_cv_odd,df_cvc_odd)
#  add_column(overlap, cv_diff = overlap$cv_matching_rt - overlap$cv_mis_rt, .after = 'part') %>% 
#  add_column(overlap, cvc_diff = overlap$cvc_matching_rt - overlap$cvc_mis_rt, .after = 'cv_diff')
#
#overlap <- merge(df_cv_odd,df_cvc_odd) %>%
#  add_column(., cv_diff = overlap$cv_matching_rt - overlap$cv_mis_rt, .after = 'part') %>%
#  add_column(., cvc_diff = overlap$cvc_matching_rt - overlap$cvc_mis_rt, .after = 'cv_diff')
#
#
#colnames(overlap)


# Subset for real words only
seg_critical_words <- subset(seg_critical, wd_status == 'word')
tapply(seg_critical_words$segRespRT, list(seg_critical_words$tar_syl_str,seg_critical_words$matching,seg_critical_words$partNum), FUN = mean)
tapply(seg_critical_words$segRespRT, list(seg_critical_words$tar_syl_str,seg_critical_words$wd_int_syl_str,seg_critical_words$partNum), FUN = mean)

ag_wd <- aggregate(seg_critical_words$segRespRT, by = list(seg_critical_words$partNum,seg_critical_words$matching,seg_critical_words$tar_syl_str), FUN = mean)
averaged_wd <- ag_wd
averaged_wd <- ag_wd %>%
  add_column(int_wd_syl = ifelse(averaged_wd$Group.2 == 'match',averaged_wd$Group.3,
                                 ifelse(averaged_wd$Group.2 != 'match' & averaged_wd$Group.3 == 'CV','CVC','CV')))
names(averaged_wd) <- c('participant','int_syl_structure_match','target_syl','rt_ms','int_wd_syl')

cvTargets_wd <- subset(averaged_wd,target_syl == 'CV')
cvcTargets_wd <- subset(averaged_wd,target_syl == 'CVC')
cvCarrier_wd <- subset(averaged_wd,int_wd_syl == 'CV')
cvcCarrier_wd <- subset(averaged_wd,int_wd_syl == 'CVC')
#t.testing
t.test(cvTargets_wd$rt_ms~cvTargets_wd$int_wd_syl)
t.test(cvcTargets_wd$rt_ms~cvcTargets_wd$int_wd_syl)
t.test(cvCarrier_wd$rt_ms~cvCarrier_wd$target_syl)
t.test(cvcCarrier_wd$rt_ms~cvcCarrier_wd$target_syl)

mydata_wd <- averaged_wd %>%
  group_by(target_syl,int_wd_syl) %>%
  summarise(average = mean(rt_ms))

#Crossover plots
ggplot(data=mydata_wd,aes(x=target_syl,y=average, group=int_wd_syl, color=int_wd_syl)) +
  geom_line() + 
  geom_point() + 
  labs(title="RTs by Target and Carrier Item Syllable Structure for Words",x="Target Structure",y= "Reaction Time (msec)")

# Subset for nonwords only
seg_critical_nonwords <- subset(seg_critical, wd_status == 'nonword')
tapply(seg_critical_nonwords$segRespRT, list(seg_critical_nonwords$tar_syl_str,seg_critical_nonwords$matching,seg_critical_nonwords$partNum), FUN = mean)
tapply(seg_critical_nonwords$segRespRT, list(seg_critical_nonwords$tar_syl_str,seg_critical_nonwords$wd_int_syl_str,seg_critical_nonwords$partNum), FUN = mean)


ag_nonwd <- aggregate(seg_critical_nonwords$segRespRT, by = list(seg_critical_nonwords$partNum,seg_critical_nonwords$matching,seg_critical_nonwords$tar_syl_str), FUN = mean)
averaged_nonwd <- ag_nonwd
averaged_nonwd <- ag_nonwd %>%
  add_column(int_wd_syl = ifelse(averaged_nonwd$Group.2 == 'match',averaged_nonwd$Group.3,
                                 ifelse(averaged_nonwd$Group.2 != 'match' & averaged_nonwd$Group.3 == 'CV','CVC','CV')))
names(averaged_nonwd) <- c('participant','int_syl_structure_match','target_syl','rt_ms','int_wd_syl')

cvTargets_nonwd <- subset(averaged_nonwd,target_syl == 'CV')
cvcTargets_nonwd <- subset(averaged_nonwd,target_syl == 'CVC')
cvCarrier_nonwd <- subset(averaged_nonwd,int_wd_syl == 'CV')
cvcCarrier_nonwd <- subset(averaged_nonwd,int_wd_syl == 'CVC')
#t.testing
t.test(cvTargets_nonwd$rt_ms~cvTargets_nonwd$int_wd_syl)
t.test(cvcTargets_nonwd$rt_ms~cvcTargets_nonwd$int_wd_syl)
t.test(cvCarrier_nonwd$rt_ms~cvCarrier_nonwd$target_syl)
t.test(cvcCarrier_nonwd$rt_ms~cvcCarrier_nonwd$target_syl)

mydata_nonwd <- averaged_nonwd %>%
  group_by(target_syl,int_wd_syl) %>%
  summarise(average = mean(rt_ms))


#Crossover plots
ggplot(data=mydata_nonwd,aes(x=target_syl,y=average, group=int_wd_syl, color=int_wd_syl)) +
  geom_line() + 
  geom_point() + 
  labs(title="RTs by Target and Carrier Item Syllable Structure for Nonwords",x="Target Structure",y= "Reaction Time (msec)")



## Meeting with Miquel
miquel <- seg_critical %>%
  group_by(tar_syl_str, wd_int_syl_str, partNum, wd_status) %>%
  summarise(average = mean(segRespRT))

miquel_wd <- subset(miquel, miquel$wd_status == 'word')
miquel_nonwd <- subset(miquel, miquel$wd_status != 'word')

# Write out files
write_csv(miquel_nonwd, "monolingual_nonwords.csv")
write_csv(miquel_wd, "monolingual_words.csv")
write_csv(miquel, "monolingual_pooled.csv")

# plot nonword 
ggplot(data=miquel_nonwd,aes(x=tar_syl_str,y=average, group=wd_int_syl_str, color=wd_int_syl_str)) +
  geom_line() + 
  geom_point() + 
  labs(title="RTs by Target and Carrier Item Syllable Structure for Nonwords",x="Target Structure",y= "Reaction Time (msec)")

# plot word
ggplot(data=miquel_wd,aes(x=tar_syl_str,y=average, group=wd_int_syl_str, color=wd_int_syl_str)) +
  geom_line() + 
  geom_point() + 
  labs(title="RTs by Target and Carrier Item Syllable Structure for Words",x="Target Structure",y= "Reaction Time (msec)")


# Need to create data set for demographics One line per participant
# demogrpahics_all.csv
# Create subset for Segmentation Experiment Demographics
# segmentation_online_demo.csv - may need to combine with output from L2 population
# partID, LexTALE-ENG, LexTale-ESP, Bilingual Langauge Profile
# Store in Box > Laboratory > Active > data > attributes
# Segmentation Lab Data by participant (only lab)
# Store in Box > Laboratory > Active > data > input