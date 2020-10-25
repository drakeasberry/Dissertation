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
my_data <- read_csv('analyze_data/output/55_online_learners_segmentation.csv')
summary(my_data)

densityplot(~segRespRTmsec, data = my_data, main = ' Segmentation Reaction Time in Milliseconds') 
stripplot(~segRespRTmsec, data = my_data, main = ' Segmentation Reaction Time in Milliseconds') 
densityplot(~log_RT, data = my_data, main = 'Segmentation Reaction as Log') 

# Monolingual Reaction Times Plots
with(my_data, bwplot(log_RT~word_initial_syl|target_syl_structure, 
                     main = 'log RT for Target Syllable Structure', 
                     xlab = 'Word Initial Syllable Structure'))
with(my_data, bwplot(log_RT~word_initial_syl|targetSyl, 
                     main = 'log RT for Target Syllables', 
                     xlab = 'Word Initial Syllable Structure'))
with(my_data, bwplot(segRespRTmsec~word_initial_syl, 
                     main = 'RT (msec) for Word Intitial Syllable Structure', 
                     xlab = 'Word Initial Syllable Structure'))
with(my_data, bwplot(segRespRTmsec~target_syl_structure, 
                     main = 'RT (msec) for Target Syllable Structure', 
                     xlab = 'Target Syllable Structure'))

# Monolingual Reaction Times Tables
# rows are syllable structure type of target
# columns are syllable structure of initial word syllable
tapply(my_data$segRespRTsec, 
       list(my_data$target_syl_structure,my_data$matching,my_data$partNum), FUN = mean)
with(my_data, bwplot(segRespRTmsec~word_initial_syl|target_syl_structure, 
                     main = 'RT (msec) by Target Syllable Structure', 
                     xlab = 'Word Initial Syllable Structure'))


#(scale function) mean - token / stdev (zscoring) 
# package(standardize)

ag_all <- aggregate(my_data$segRespRTmsec, 
                    by = list(my_data$partNum,my_data$matching,my_data$target_syl_structure), FUN = mean)
cv_match_all <- subset(ag_all,Group.2 == 'match' & Group.3 == 'CV')
cvc_match_all <- subset(ag_all,Group.2 == 'match' & Group.3 == 'CVC')
cv_mismatch_all <- subset(ag_all,Group.2 == 'mismatch' & Group.3 == 'CV')
cvc_mismatch_all <- subset(ag_all,Group.2 == 'mismatch' & Group.3 == 'CVC')

averaged_all <- ag_all
averaged_all <- ag_all %>%
  add_column(int_wd_syl = ifelse(averaged_all$Group.2 == 'match',averaged_all$Group.3,
                                 ifelse(averaged_all$Group.2 != 'match' & averaged_all$Group.3 == 'CV'
                                        ,'CVC','CV')))
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
  labs(title="RTs by Target and Carrier Item Syllable Structure Pooled",
       x="Target Structure",
       y= "Reaction Time (msec)")


# Subset for real words only
real_words <- subset(my_data, word_status == 'word')
tapply(real_words$segRespRTmsec, 
       list(real_words$target_syl_structure, real_words$matching, real_words$partNum), FUN = mean)
tapply(real_words$segRespRTmsec,
       list(real_words$target_syl_structure, real_words$word_initial_syl, real_words$partNum), FUN = mean)

ag_wd <- aggregate(real_words$segRespRTmsec, 
                   by = list(real_words$partNum,real_words$matching,
                             real_words$target_syl_structure), FUN = mean)

averaged_wd <- ag_wd
averaged_wd <- ag_wd %>%
  add_column(int_wd_syl = ifelse(averaged_wd$Group.2 == 'match',averaged_wd$Group.3,
                                 ifelse(averaged_wd$Group.2 != 'match' & averaged_wd$Group.3 == 'CV',
                                        'CVC','CV')))
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
  labs(title="RTs by Target and Carrier Item Syllable Structure for Words",
       x="Target Structure",
       y= "Reaction Time (msec)")

# Subset for nonwords only
non_words <- subset(my_data, word_status == 'nonword')
tapply(non_words$segRespRTmsec, 
       list(non_words$target_syl_structure, non_words$matching,
            non_words$partNum), FUN = mean)
tapply(non_words$segRespRTmsec, 
       list(non_words$target_syl_structure, non_words$word_initial_syl,
            non_words$partNum), FUN = mean)


ag_nonwd <- aggregate(non_words$segRespRTmsec, 
                      by = list(non_words$partNum, non_words$matching, non_words$target_syl_structure),
                      FUN = mean)
averaged_nonwd <- ag_nonwd
averaged_nonwd <- ag_nonwd %>%
  add_column(int_wd_syl = ifelse(averaged_nonwd$Group.2 == 'match',averaged_nonwd$Group.3,
                                 ifelse(averaged_nonwd$Group.2 != 'match' & averaged_nonwd$Group.3 == 'CV',
                                        'CVC','CV')))
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
  labs(title="RTs by Target and Carrier Item Syllable Structure for Nonwords",
       x="Target Structure",
       y= "Reaction Time (msec)")


## Meeting with Miquel
miquel <- my_data %>%
  group_by(target_syl_structure, word_initial_syl, partNum, word_status) %>%
  summarise(average = mean(segRespRTmsec))

miquel_wd <- subset(miquel, miquel$word_status == 'word')
miquel_nonwd <- subset(miquel, miquel$word_status != 'word')

# plot nonword 
ggplot(data=miquel_nonwd,aes(x=target_syl_structure,y=average, group=word_initial_syl, color=word_initial_syl)) +
  geom_line() + 
  geom_point() + 
  labs(title="RTs by Target and Carrier Item Syllable Structure for Nonwords",
       x="Target Structure",
       y= "Reaction Time (msec)")

# plot word
ggplot(data=miquel_wd,aes(x=target_syl_structure,y=average, group=word_initial_syl, color=word_initial_syl)) +
  geom_line() + 
  geom_point() + 
  labs(title="RTs by Target and Carrier Item Syllable Structure for Words",
       x="Target Structure",
       y= "Reaction Time (msec)")