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

# Read in experimental dataset
seg_critical <- read_csv('analyze_data/output/44_online_natives_segmentation.csv')

## start plotting
## Looking at Response Times
#seg_critical <- seg_critical_hits %>%
#  #left_join(.,calc_seg_part,by='partNum') %>% # Join reported group classification
#  mutate(segRespRT = round(segRespRT * 1000, 2),
#         log_RT = log(segRespRT)) %>% # convert seconds to milliseconds, create log rt column
#  select('partNum','block': 'log_RT', 'age':'preferLanguage','date':'session') %>% # reorder columns
#  subset(.,fillerCarrier == 'critical' & segRespCorr == 1) %>% # get only critical items repsonses
#  subset(.,segRespRT >= 200 & segRespRT <= 1500) %>% # remove repsonse below 200ms
#  subset(.,partNum %ni% high_miss_seg_critical_users$vars)
#
#valid_part <- unique(seg_critical$partNum)
##saveRDS(valid_part, file="../Demographics/mono_lemma_participants")
#
## Write a csv file with valid data points for participants who meet inclusion criteria
#write_csv(seg_critical, '44_monolingual_valid_response_critical_items.csv')
#
## Create subset with only participant responses who meet inclusion criteria
#participant_responses_all <- subset(drop_participants, drop_participants$partNum %in% valid_part)
#write_csv(participant_responses_all, '44_monolingual_all_segmentation_responses.csv')
#
## Run to here to check data validation participants provided good data 
#
#segmentation_data <- participant_responses_all %>% 
#  subset(., fillerCarrier == 'critical' & segResp == 'b') %>% # 100 critical errors removed
#  mutate(segRespRTmsec = round(segRespRT * 1000),
#         log_RT = log(segRespRT)) %>%
#  subset(., segRespRTmsec > 200) %>% # removed 1 point
#  subset(., segRespRTmsec < 1500) %>% # removed 47 points
#  rename(segRespRTsec = segRespRT, word = expWord, word_status = wd_status,
#         word_initial_syl = wd_int_syl_str, target_syl_structure = tar_syl_str,
#         targetSyl = tar_syl, word_initial_3_letters = first_3) %>% 
#  select("partNum","segRespRTsec", "segRespRTmsec", "log_RT", "lemma", "word", 
#         "word_initial_3_letters", "word_status","word_initial_syl", "targetSyl", 
#         "target_syl_structure","matching", "block")
#
## Check to ensure no column only contains one unique value
#segmentation_data %>% 
#  summarise_all(n_distinct)
#
## Check minimum and maximum reaction times 
#segmentation_data %>% 
#  summarise_at(vars(segRespRTmsec),list(quickest = min, slowest = max))
#
## For PI Advisor
#write_csv(segmentation_data, 'natives.csv')

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

densityplot(~segRespRTmsec, data = seg_critical, main = ' Segmentation Reaction Time in Milliseconds') 
stripplot(~segRespRTmsec, data = seg_critical, main = ' Segmentation Reaction Time in Milliseconds') 
densityplot(~log_RT, data = seg_critical, main = 'Segmentation Reaction as Log') 

# Monolingual Reaction Times Plots
with(seg_critical, bwplot(log_RT~word_initial_syl|target_syl_structure, main = 'log RT for Target Syllable Structure', xlab = 'Word Initial Syllable Structure'))
with(seg_critical, bwplot(log_RT~word_initial_syl|targetSyl, main = 'log RT for Target Syllables', xlab = 'Word Initial Syllable Structure'))
with(seg_critical, bwplot(segRespRTmsec~word_initial_syl, main = 'RT (msec) for Word Intitial Syllable Structure', xlab = 'Word Initial Syllable Structure'))
with(seg_critical, bwplot(segRespRTmsec~target_syl_structure, main = 'RT (msec) for Target Syllable Structure', xlab = 'Target Syllable Structure'))

# Monolingual Reaction Times Tables
# rows are syllable structure type of target
# columns are syllable structure of initial word syllable
tapply(seg_critical$segRespRTsec, list(seg_critical$target_syl_structure,seg_critical$matching,seg_critical$partNum), FUN = mean)
#tapply(seg_critical$segRespRT, list(seg_critical$tar_syl,seg_critical$matching,seg_critical$partNum), FUN = mean)
#tapply(seg_critical$segRespRT, list(seg_critical$target_syl_structure,seg_critical$matching,seg_critical$partGroup), FUN = min)
#Spanish Only
#esp <- subset(seg_critical, partGroup == 'Spanish')
with(seg_critical, bwplot(segRespRTmsec~word_initial_syl|target_syl_structure, main = 'RT (msec) by Target Syllable Structure', xlab = 'Word Initial Syllable Structure'))
#df <- tibble(tapply(esp$segRespRT, list(esp$target_syl_structure,esp$matching,esp$partNum), FUN = mean))

#(scale function) mean - token / stdev (zscoring) 
# package(standardize)
ag_all <- aggregate(seg_critical$segRespRTmsec, by = list(seg_critical$partNum,seg_critical$matching,seg_critical$target_syl_structure), FUN = mean)
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
seg_critical_words <- subset(seg_critical, word_status == 'word')
tapply(seg_critical_words$segRespRTmsec, list(seg_critical_words$target_syl_structure,seg_critical_words$matching,seg_critical_words$partNum), FUN = mean)
tapply(seg_critical_words$segRespRTmsec, list(seg_critical_words$target_syl_structure,seg_critical_words$word_initial_syl,seg_critical_words$partNum), FUN = mean)

ag_wd <- aggregate(seg_critical_words$segRespRTmsec, by = list(seg_critical_words$partNum,seg_critical_words$matching,seg_critical_words$target_syl_structure), FUN = mean)
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
seg_critical_nonwords <- subset(seg_critical, word_status == 'nonword')
tapply(seg_critical_nonwords$segRespRTmsec, list(seg_critical_nonwords$target_syl_structure,seg_critical_nonwords$matching,seg_critical_nonwords$partNum), FUN = mean)
tapply(seg_critical_nonwords$segRespRTmsec, list(seg_critical_nonwords$target_syl_structure,seg_critical_nonwords$word_initial_syl,seg_critical_nonwords$partNum), FUN = mean)


ag_nonwd <- aggregate(seg_critical_nonwords$segRespRTmsec, by = list(seg_critical_nonwords$partNum,seg_critical_nonwords$matching,seg_critical_nonwords$target_syl_structure), FUN = mean)
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
  group_by(target_syl_structure, word_initial_syl, partNum, word_status) %>%
  summarise(average = mean(segRespRTmsec))

miquel_wd <- subset(miquel, miquel$word_status == 'word')
miquel_nonwd <- subset(miquel, miquel$word_status != 'word')

# Write out files
#write_csv(miquel_nonwd, "monolingual_nonwords.csv")
#write_csv(miquel_wd, "monolingual_words.csv")
#write_csv(miquel, "monolingual_pooled.csv")

# plot nonword 
ggplot(data=miquel_nonwd,aes(x=target_syl_structure,y=average, group=word_initial_syl, color=word_initial_syl)) +
  geom_line() + 
  geom_point() + 
  labs(title="RTs by Target and Carrier Item Syllable Structure for Nonwords",x="Target Structure",y= "Reaction Time (msec)")

# plot word
ggplot(data=miquel_wd,aes(x=target_syl_structure,y=average, group=word_initial_syl, color=word_initial_syl)) +
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