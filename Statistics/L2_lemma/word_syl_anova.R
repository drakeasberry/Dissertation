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
my_data <- read_csv('analyze_data/output/55_online_learners_segmentation.csv')


# Transform data in long form with 1 row per participant per condition
# List columns to group by
grouping <- c("partNum", "group", "word_status", "word_initial_syl", 
              "target_syl_structure", "matching")

# Aggregaates and transforms data into long form
# Adds columns for median of RT in msec and log
my_data_long <- trans_long(my_data, grouping) 


# Create subgroups for Spanish learners and native speakers
learners <- my_data_long


# Group data by target syllable structure, matching condition, and word status, 
grouping_stats <- c("word_initial_syl", "matching", "word_status")

# Summary statistics for reaction time
# Reaction time in miliseconds
learners %>% 
  summary_stats(., grouping_stats, "median_RTmsec", "mean_sd")

# Reaction time after log transformation
learners %>% 
  summary_stats(., grouping_stats, "median_RTlog", "mean_sd")


# Visualize Descriptive Data
# learners
bxp_learners <- learners %>% 
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
  labs(title = "L2 Spanish by Word Initial Syllable",
       x = "Word Initial Syllable Structure",
       y = "Reaction Time (msec)") +
  scale_color_manual(name = "Condition", values = c('darkorchid4', 'goldenrod4'))
bxp_learners  

# Check for outliers
outlier_learner <- learners %>% 
  outlier_chk(., grouping_stats, "median_RTmsec")

# Check for normality
normality_learner <- learners %>% 
  normality_chk(., grouping_stats, "median_RTmsec")


# Create QQ plots
# learners by milliseconds
ggqqplot(learners, "median_RTmsec", ggtheme = theme_bw(), 
         title = "QQ Plot by Word Initial Syllable in Milliseconds by L2 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both") 

# learners by log values
ggqqplot(learners, "median_RTlog", ggtheme = theme_bw(),
         title = "QQ Plot by Word Initial Syllable in log by L2 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both")


# Run inferential statistics learner group
# Run 3 way repeated measures anova
aov_learners <- aov_ez("partNum", "median_RTlog", learners, within = c(grouping_stats))
aov_learners
## main effect of word initial syllable condition
## 3 way interaction between word initial syllable, matching and word status


# Significant Main Effect Exploration
# learners t.test for word initial syllable
t.test(learners$median_RTlog ~ learners$word_initial_syl, paired = TRUE)
## is significant

# Descriptives to check direction of effect
with(learners, tapply(median_RTlog, word_initial_syl, FUN = mean))
## CV word initial syllables responded to faster than CVC word initial syllables


# Estimated Marginal Means
# get tabled results of estimated marginal means
wdsyl_main <- emmeans(aov_learners, pairwise ~ word_initial_syl) 
wdsyl_main


# Learner plots
# Main effect of word initial syllable condition
l2_wdsyl_main <- afex_plot(aov_learners, 
                         x = "word_initial_syl", 
                         error = "within",
                         data_plot = FALSE,
                         mapping = c("color", "shape")) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Word Initial Syllable",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4')) +
  theme(legend.position = "none")
l2_wdsyl_main


# Break down the three way interaction between word initial syllable, word status and matching condition
# Drop word status
grouping_a <- grouping[! grouping %in% c("word_status")]
grouping_stats_a <- grouping_stats[! grouping_stats %in% c("word_status")]

# Convert and aggregate data into long form
learners_a <- trans_long(my_data, grouping_a)

# Run 2 way repeated measures anova
aov_learners_a <- aov_ez("partNum", "median_RTlog", learners_a, within = c(grouping_stats_a))
aov_learners_a
## main effect of word initial syllable condition
## no significant interactions


# Significant Main Effect Exploration
# learners t.test for word initial syllable
t.test(learners_a$median_RTlog ~ learners_a$word_initial_syl, paired = TRUE)
## is significant

# Descriptives to check direction of effect
with(learners_a, tapply(median_RTlog, word_initial_syl, FUN = mean))
## CV word initial syllables responded to faster than CVC word initial syllables


# Estimated Marginal Means
# get tabled results of estimated marginal means
wdsyl_main_a <- emmeans(aov_learners_a, pairwise ~ word_initial_syl) 
wdsyl_main_a


# Learner plots
# Main effect of word initial syllable condition
l2_wdsyl_main_a <- afex_plot(aov_learners_a, 
                           x = "word_initial_syl", 
                           error = "within",
                           data_plot = FALSE,
                           mapping = c("color", "shape")) +
  labs(title = "Estimated Marginal Means L2 Spanish (No Lexicality)",
       x = "Word Initial Syllable",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4')) +
  theme(legend.position = "none")
l2_wdsyl_main_a


# Drop matching
grouping_b <- grouping[! grouping %in% c("matching", "target_syl_structure")]
grouping_stats_b <- grouping_stats[! grouping_stats %in% c("matching")]

# Convert and aggregate data into long form
learners_b <- trans_long(my_data, grouping_b)

# Run 2 way repeated measures anova
aov_learners_b <- aov_ez("partNum", "median_RTlog", learners_b, within = c(grouping_stats_b))
aov_learners_b
## main effect of word initial syllable condition
## no significant interactions


# Significant Main Effect Exploration
# learners t.test for word initial syllable
t.test(learners_b$median_RTlog ~ learners_b$word_initial_syl, paired = TRUE)
## is significant

# Descriptives to check direction of effect
with(learners_b, tapply(median_RTlog, word_initial_syl, FUN = mean))
## CV word initial syllables responded to faster than CVC word initial syllables


# Estimated Marginal Means
# get tabled results of estimated marginal means
wdsyl_main_b <- emmeans(aov_learners_b, pairwise ~ word_initial_syl) 
wdsyl_main_b


# Learner plots
# Main effect of word initial syllable condition
l2_wdsyl_main_b <- afex_plot(aov_learners_b, 
                             x = "word_initial_syl", 
                             error = "within",
                             data_plot = FALSE,
                             mapping = c("color", "shape")) +
  labs(title = "Estimated Marginal Means L2 Spanish (No Matching)",
       x = "Word Initial Syllable",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4')) +
  theme(legend.position = "none")
l2_wdsyl_main_b


# Drop word initial syllable
grouping_c <- grouping[! grouping %in% c("word_initial_syl", "target_syl_structure")]
grouping_stats_c <- grouping_stats[! grouping_stats %in% c("word_initial_syl")]

# Convert and aggregate data into long form
learners_c <- trans_long(my_data, grouping_c)

# Run 2 way repeated measures anova
aov_learners_c <- aov_ez("partNum", "median_RTlog", learners_c, within = c(grouping_stats_c))
aov_learners_c
## main effect of matching condition
## no significant interactions


# Significant Main Effect Exploration
# learners t.test for matching conditions
t.test(learners_c$median_RTlog ~ learners_c$matching, paired = TRUE)
## is significant

# Descriptives to check direction of effect
with(learners_c, tapply(median_RTlog, matching, FUN = mean))
## matching condition responded to faster than mismatching condition


# Estimated Marginal Means
# get tabled results of estimated marginal means
mat_main_c <- emmeans(aov_learners_c, pairwise ~ matching) 
mat_main_c


# Learner plots
# Main effect of word initial syllable condition
l2_mat_main_c <- afex_plot(aov_learners_c, 
                             x = "matching", 
                             error = "within",
                             data_plot = FALSE,
                             mapping = c("color", "shape")) +
  labs(title = "Estimated Marginal Means L2 Spanish (No Word Initial Syllable)",
       x = "Matching Condition",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4')) +
  theme(legend.position = "none")
l2_mat_main_c



# Remove temporary data variables in environment
# Remove dataframes following analysis
rm(my_data, my_data_long, learners, learners_a, learners_b, learners_c)

# Remove checks and unused plots
rm(normality_learner, outlier_learner)

out_dir = 'analyze_data/output/figures/by_word/'

# Save tabled data
# https://tex.stackexchange.com/questions/481802/reporting-r-results-in-latex

# Save plots
ggsave('learners_descriptive_data.png', bxp_learners, 'png', out_dir)
ggsave('learners_wdsyl_main.png', l2_wdsyl_main, 'png', out_dir)
ggsave('no_lex_wdsyl_main.png', l2_wdsyl_main_a, 'png', out_dir)
ggsave('no_mat_wdsyl_main.png', l2_wdsyl_main_b, 'png', out_dir)
ggsave('no_wdsyl_mat_main.png', l2_mat_main_c, 'png', out_dir)
