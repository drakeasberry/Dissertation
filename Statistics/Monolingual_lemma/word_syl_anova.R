#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(readr)
library(emmeans)
library(ggplot2)
library(cowplot)


# Soruce Scripts containing functions
source("../../Scripts_Dissertation/segmentation_rm_anova_script.R")


# Read in data file
my_data <- read_csv('analyze_data/output/44_online_natives_segmentation.csv')


# Transform data in long form with 1 row per participant per condition
# List columns to group by
grouping <- c("partNum", "group", "word_status", "word_initial_syl", 
              "target_syl_structure", "matching")

# Aggregaates and transforms data into long form
# Adds columns for median of RT in msec and log
my_data_long <- trans_long(my_data, grouping) 


# Create subgroups for Spanish learners and native speakers
natives <- my_data_long


# Group data by target syllable structure, matching condition, and word status, 
grouping_stats <- c("word_initial_syl", "matching", "word_status")

# Summary statistics for reaction time
# Reaction time in miliseconds
natives %>% 
  summary_stats(., grouping_stats, "median_RTmsec", "mean_sd")

# Reaction time after log transformation
natives %>% 
  summary_stats(., grouping_stats, "median_RTlog", "mean_sd")


# Visualize Descriptive Data
# Natives
bxp_natives <- natives %>% 
  mutate(wd_new = factor(word_status, levels = c("word", "nonword"),
                         labels = c("Word", "Nonword")),
         mat_new = factor(matching, levels = c("match", "mismatch"),
                          labels = c("Matching", "Mismatching"))) %>% 
  ggplot(aes(x = word_initial_syl,
             y = median_RTmsec,
             color = mat_new)) +
  geom_boxplot(fill = NA, position = position_dodge(1)) +
  geom_violin(fill = NA, position = position_dodge(1)) +
  facet_grid(. ~ wd_new) +
  labs(title = "L1 Spanish by Word Initial Syllable",
       x = "Word Initial Syllable Structure",
       y = "Reaction Time (msec)") +
  scale_color_manual(name = "Condition", values = c('darkorchid4', 'goldenrod4'))
bxp_natives  

# Check for outliers
# Check pooled environment
#my_online_l2 <- read_csv("../L2_lemma/analyze_data/output/55_online_learners_segmentation.csv")
#my_data_online <- rbind(my_data, my_online_l2) %>% 
#  trans_long(., grouping) 
#
#outlier_data <- my_data_online %>% 
#  outlier_chk(., grouping_stats, "median_RTmsec")

outlier_native <- natives %>% 
  outlier_chk(., grouping_stats, "median_RTmsec")

# Check for normality
normality_native <- natives %>% 
  normality_chk(., grouping_stats, "median_RTmsec")


# Create QQ plots
# Natives by milliseconds
ggqqplot(natives, "median_RTmsec", ggtheme = theme_bw(), 
         title = "QQ Plot by Word Initial Syllable in Milliseconds by L1 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both") 

# Natives by log values
ggqqplot(natives, "median_RTlog", ggtheme = theme_bw(),
         title = "QQ Plot by Word Initial Syllable in log by L1 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both")


# Run inferential statistics Native group
# Run 3 way repeated measures anova
aov_natives <- aov_ez("partNum", "median_RTlog", natives, within = c(grouping_stats))
aov_natives
## main effect of matching condition and trending for word status
## no signficant interactions

# Regroup to run paired t-test for matching/mismatching over all other conditions
grouping_mat <- grouping[! grouping %in% c("word_status", "word_initial_syl",
                                           "target_syl_structure", "group")]
data_mat_ag <- trans_long(my_data, grouping_mat)


# Significant Main Effect Exploration
# Natives t.test for matching condition
t.test(data_mat_ag$median_RTlog ~ data_mat_ag$matching, paired = TRUE, 
       alternative = "less")
## is significant

# Descriptives to check direction of effect
with(data_mat_ag, tapply(median_RTlog, matching, FUN = mean))
## matching condition responded to faster than mismatching condition


# Significant Main Effect Trending Exploration
# Regroup to run paired t-test for word status over all other conditions 
grouping_lex <- grouping[! grouping %in% c("target_syl_structure", "word_initial_syl",
                                           "matching", "group")]
data_lex_ag <- my_data %>% 
  trans_long(., grouping_lex)

# Natives t.test for word status (trending)
t.test(data_lex_ag$median_RTlog ~ data_lex_ag$word_status, paired = TRUE)
## is not significant

# Descriptives to check direction of effect
with(data_lex_ag, tapply(median_RTlog, word_status, FUN = mean))
## words responded to faster than nonwords, but not significantly so

# Estimated Marginal Means
# get tabled results of estimated marginal means
mat_main <- emmeans(aov_natives, pairwise ~ matching) 
mat_main

lex_main <- emmeans(aov_natives, pairwise ~ word_status) 
lex_main

# Native plots
# Main effect of matching condition
l1_mat_main <- afex_plot(aov_natives, 
                         x = "matching", 
                         error = "within",
                         factor_levels = list(matching = c(match = "Matching", 
                                                           mismatch = "Mismatching")),
                         data_plot = FALSE,
                         mapping = c("color", "shape")) +
  labs(title = "Estimated Marginal Means L1 Spanish",
       x = "Matching Condition",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4')) +
  theme(legend.position = "none")
l1_mat_main

# Main effect of lexicality
l1_lex_main <- afex_plot(aov_natives, 
                         x = "word_status", 
                         error = "within",
                         factor_levels = list(word_status = c(word = "Word", 
                                                              nonword = "Noword")),
                         data_plot = FALSE,
                         mapping = c("color", "shape")) +
  labs(title = "Estimated Marginal Means L1 Spanish",
       x = "Lexicality",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4')) +
  theme(legend.position = "none")
l1_lex_main


# Interaction breakdown
## No significant interactions to explore


# Remove temporary data variables in environment
# Remove dataframes following analysis
rm(my_data, my_data_long, learners, natives, words_learners, nonwords_learners, 
   cvc_learners, cv_learners)

# Remove checks and unused plots
rm(l2_mat_lex_int, l2_wdsyl_mat_int, normality_learner, normality_native, 
   outlier_learner, outlier_native)

out_dir = 'analyze_data/output/figures/by_word/'

# Save tabled data
# https://tex.stackexchange.com/questions/481802/reporting-r-results-in-latex

# Save plots
ggsave('natives_descriptive_data.png', bxp_natives, 'png', out_dir)
ggsave('natives_mat_main.png', l1_mat_main, 'png', out_dir)
