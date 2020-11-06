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
grouping_stats <- c("target_syl_structure", "matching", "word_status")

# Summary statistics for reaction time
# Reaction time in miliseconds
natives %>% 
  summary_stats(., grouping_stats, "median_RTmsec", "mean_sd")

# Reaction time after log transformation
natives %>% 
  summary_stats(., grouping_stats, "median_RTlog", "mean_sd")


# Natives
bxp_natives <- natives %>% 
  mutate(wd_new = factor(word_status, levels = c("word", "nonword"),
                         labels = c("Word", "Nonword")),
         mat_new = factor(matching, levels = c("match", "mismatch"),
                          labels = c("Matching", "Mismatching"))) %>% 
  ggplot(aes(x = target_syl_structure,
             y = median_RTmsec,
             color = mat_new)) +
  geom_boxplot(fill = NA, position = position_dodge(1)) +
  geom_violin(fill = NA, position = position_dodge(1)) +
  facet_grid(. ~ wd_new) +
  labs(title = "L1 Spanish by Target Syllable",
       x = "Target Syllable Structure",
       y = "Reaction Time (msec)") +
  scale_color_manual(name = "Condition", values = c('darkorchid4', 'goldenrod4'))
bxp_natives 


# Check for outliers
outlier_native <- natives %>% 
  outlier_chk(., grouping_stats, "median_RTmsec")

# Check for normality
normality_native <- natives %>% 
  normality_chk(., grouping_stats, "median_RTmsec")


# Create QQ plots
# Natives by milliseconds
ggqqplot(natives, "median_RTmsec", ggtheme = theme_bw(), 
         title = "QQ Plot by Target Syllable in Milliseconds by L1 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both") 

# Natives by log values
ggqqplot(natives, "median_RTlog", ggtheme = theme_bw(),
         title = "QQ Plot by Target Syllable in log by L1 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both")


# Run inferential statistics Native group
# Run 3 way repeated measures anova
aov_natives <- aov_ez("partNum", "median_RTlog", natives, within = c(grouping_stats))
aov_natives
## main effect of matching condition
## no signficant interactions


# Significant Main Effect Exploration
# Natives t.test for matching condition
t.test(natives$median_RTlog ~ natives$matching, paired = TRUE)
## is significant

# Descriptives to check direction of effect
with(natives, tapply(median_RTlog, matching, FUN = mean))
## matching condition responded to faster than mismatching condition


# Estimated Marginal Means
# get tabled results of estimated marginal means
mat_main <- emmeans(aov_natives, pairwise ~ matching) 
mat_main


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


# Remove temporary data variables in environment
# Remove dataframes following analysis
rm(my_data, my_data_long, learners, natives, words_learners, nonwords_learners)

# Remove checks and unused plots
rm(l2_mat_lex_int, normality_learner, normality_native, outlier_learner, outlier_native)


# Save all analyses
out_dir = 'analyze_data/output/figures/by_target/'

# Save tabled data
# https://tex.stackexchange.com/questions/481802/reporting-r-results-in-latex

# Save plots
ggsave('natives_descriptive_data.png', bxp_natives, 'png', out_dir)
ggsave('natives_mat_main.png', l1_mat_main, 'png', out_dir)
