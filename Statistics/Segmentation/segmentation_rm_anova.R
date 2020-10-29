#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(readr)


# Soruce Scripts containing functions
source("../../Scripts_Dissertation/segmentation_rm_anova_script.R")

# Create 'not in' function
'%ni%' <- Negate('%in%')

# Surpress all readr messages by default
# https://www.reddit.com/r/rstats/comments/739vf6/how_to_turn_off_readrs_messages_by_default/
options(readr.num_columns = 0)

# Read in data file
my_data <- read_csv('analyze_data/output/45_lab_segmentation.csv')

# Transform data in long form with 1 row per participant per condition
# List columns to group by
grouping <- c("partNum", "group", "word_status", "word_initial_syl", 
              "target_syl_structure", "matching")
# Aggregaates and transforms data into long form
# Adds median of RT in msec and log
my_data_long <- trans_long(my_data, grouping) 


# Create subgroups for Spanish learners and native speakers
learners <- part_group(my_data_long, 'English')
natives <- part_group(my_data_long, 'Spanish')

# Group data by word initial syllable, matching condition, and word status, 
# then summary statistics for reaction time
# Reaction time in miliseconds
grouping_stats <- c("word_initial_syl", "target_syl_structure", "matching", "word_status")

learners %>% 
  summary_stats(., grouping_stats, "median_RTmsec", "mean_sd")
natives %>% 
  summary_stats(., grouping_stats, "median_RTmsec", "mean_sd")

# Reaction time after log transformation
learners %>% 
  summary_stats(., grouping_stats, "median_RTlog", "mean_sd")
natives %>% 
  summary_stats(., grouping_stats, "median_RTlog", "mean_sd")



# Run the analysis by target syllable
by_target <- c("target_syl_structure", "matching", "word_status")

# Visualize learner data
bxp_tar_learners <- ggboxplot(learners, "target_syl_structure", "median_RTmsec",
                              color = "matching", 
                              palette = "jco",
                              title = "L2 Spanish by Target Syllable",
                              xlab = "Target Syllable Structure",
                              ylab = "Median Reaction Time (msec)",
                              facet.by = "word_status") %>% 
  print()

# Visualize native data
bxp_tar_natives <- ggboxplot(natives, "target_syl_structure", "median_RTmsec",
                             color = "matching", 
                             palette = "jco",
                             title = "L1 Spanish by Target Syllable",
                             xlab = "Target Syllable Structure",
                             ylab = "Median Reaction Time (msec)",
                             facet.by = "word_status") %>% 
  print()

# Check for outliers
outlier_by_tar_learner <- learners %>% 
  outlier_chk(., by_target, "median_RTmsec")
outlier_by_tar_native <- natives %>% 
  outlier_chk(., by_target, "median_RTmsec")

# Check for normality
normality_by_tar_learner <- learners %>% 
  normality_chk(., by_target, "median_RTmsec")
normality_by_tar_native <- natives %>% 
  normality_chk(., by_target, "median_RTmsec")


# Create QQ plots
# Learners by milliseconds
msec_tar_L2_qqplt <- ggqqplot(learners, "median_RTmsec", ggtheme = theme_bw(), 
                              title = "QQ Plot by Target Syllable in Milliseconds by L2 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both") 
print(msec_tar_L2_qqplt)

# Learners by log values
log_tar_L2_qqplt <- ggqqplot(learners, "median_RTlog", ggtheme = theme_bw(),
                             title = "QQ Plot by Target Syllable in log by L2 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both")
print(log_tar_L2_qqplt)

# Natives by milliseconds
msec_tar_L1_qqplt <- ggqqplot(natives, "median_RTmsec", ggtheme = theme_bw(), 
                              title = "QQ Plot by Target Syllable in Milliseconds by L1 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both") 
print(msec_tar_L1_qqplt)

# Natives by milliseconds
log_tar_L1_qqplt <- ggqqplot(natives, "median_RTlog", ggtheme = theme_bw(),
                             title = "QQ Plot by Target Syllable in log by L1 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both")
print(log_tar_L1_qqplt)

# Run 3 way repeated measures anova
aov_tar_learners <- seg_rm_anova(learners, by_target, "partNum", "median_RTlog")
aov_tar_natives <- seg_rm_anova(natives, by_target, "partNum", "median_RTlog")



# Run analysis by word initial syllable
by_word <- c("word_initial_syl", "matching", "word_status")

# Visualize learner data
bxp_wd_learners <- ggboxplot(learners, "word_initial_syl", "median_RTmsec",
                             color = "matching", 
                             palette = "jco",
                             title = "L2 Spanish by Word Initial Syllable",
                             xlab = "Word Initial Syllable Structure",
                             ylab = "Median Reaction Time (msec)",
                             facet.by = "word_status") %>% 
  print()

# Visualize native data
bxp_wd_natives <- ggboxplot(natives, "word_initial_syl", "median_RTmsec",
                            color = "matching", 
                            palette = "jco",
                            title = "L1 Spanish by Word Initial Syllable",
                            xlab = "Word Initial Syllable Structure",
                            ylab = "Median Reaction Time (msec)",
                            facet.by = "word_status") %>% 
  print()

# Check for outliers
outlier_by_wd_learner <- learners %>% 
  outlier_chk(., by_word, "median_RTmsec")
outlier_by_wd_native <- natives %>% 
  outlier_chk(., by_word, "median_RTmsec")

# Check for normality
normality_by_wd_learner <- learners %>% 
  normality_chk(., by_word, "median_RTmsec")
normality_by_wd_native <- natives %>% 
  normality_chk(., by_word, "median_RTmsec")


# Create QQ plots
# Learners by milliseconds
msec_wd_L2_qqplt <- ggqqplot(learners, "median_RTmsec", ggtheme = theme_bw(), 
                             title = "QQ Plot by Word Initial Syllable in Milliseconds by L2 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both") 
print(msec_wd_L2_qqplt)

# Learners by log values
log_wd_L2_qqplt <- ggqqplot(learners, "median_RTlog", ggtheme = theme_bw(),
                            title = "QQ Plot by Word Initial Syllable in log by L2 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both")
print(log_wd_L2_qqplt)

# Natives by milliseconds
msec_wd_L1_qqplt <- ggqqplot(natives, "median_RTmsec", ggtheme = theme_bw(), 
                             title = "QQ Plot by Word Initial Syllable in Milliseconds by L1 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both") 
print(msec_wd_L1_qqplt)

# Natives by milliseconds
log_wd_L1_qqplt <- ggqqplot(natives, "median_RTlog", ggtheme = theme_bw(),
                            title = "QQ Plot by Word Initial Syllable in log by L1 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both")
print(log_wd_L1_qqplt)

# Run 3 way repeated measures anova
aov_wd_learners <- seg_rm_anova(learners, by_word, "partNum", "median_RTlog")
aov_wd_natives <- seg_rm_anova(natives, by_word, "partNum", "median_RTlog")