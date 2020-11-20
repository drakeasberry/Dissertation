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
my_data <- read_csv('analyze_data/output/45_lab_segmentation.csv')


# Transform data in long form with 1 row per participant per condition
# List columns to group by
grouping <- c("partNum", "group", "word_status", "word_initial_syl", 
              "target_syl_structure", "matching")

# Aggregaates and transforms data into long form
# Adds columns for median of RT in msec and log
my_data_long <- trans_long(my_data, grouping) 


# Create subgroups for Spanish learners and native speakers
learners <- part_group(my_data_long, 'English')
natives <- part_group(my_data_long, 'Spanish')


# Group data by target syllable structure, matching condition, and word status, 
grouping_stats <- c("target_syl_structure", "matching", "word_status")

# Summary statistics for reaction time
# Reaction time in miliseconds
learners %>% 
  summary_stats(., grouping_stats, "median_RTmsec", "mean_sd")

natives %>% 
  summary_stats(., grouping_stats, "median_RTmsec", "mean_sd")

# Reaction time after log transformation
learners %>% 
  summary_stats(., grouping_stats, "median_RTlog", "mean_sd")

natives %>% 
  summary_stats(., grouping_stats, "median_RTlog", "mean_sd")


# Visualize Descriptive Data
# Learners
bxp_learners <- learners %>% 
  mutate(wd_new = factor(word_status, levels = c("word", "nonword"),
                         labels = c("Word", "Nonword")),
         mat_new = factor(matching, levels = c("matching", "mismatching"),
                          labels = c("Matching", "Mismatching"))) %>% 
  ggplot(aes(x = target_syl_structure,
             y = median_RTmsec,
             color = mat_new)) +
  geom_boxplot(fill = NA, position = position_dodge(1)) +
  geom_violin(fill = NA, position = position_dodge(1)) +
  facet_wrap(. ~ wd_new) +
  labs(title = "L2 Spanish by Target Syllable",
       x = "Target Syllable Structure",
       y = "Reaction Time (msec)") +
  scale_color_manual(name = "Condition", values = c('darkorchid4', 'goldenrod4'))
bxp_learners

# Natives
bxp_natives <- natives %>% 
  mutate(wd_new = factor(word_status, levels = c("word", "nonword"),
                         labels = c("Word", "Nonword")),
         mat_new = factor(matching, levels = c("matching", "mismatching"),
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
# Check pooled data
outlier_data <- my_data_long %>% 
  outlier_chk(., grouping_stats, "median_RTmsec")
## part008 only extreme outlier in all 45 participants

# check in learner group
outlier_learner <- learners %>% 
  outlier_chk(., grouping_stats, "median_RTmsec")
## part008 is only extreme outlier 

# outliers after log transformation
outlier_learner_log <- learners %>% 
  outlier_chk(., grouping_stats, "median_RTlog")
## part008 is not outlier in log transformed data

# check in native group
outlier_native <- natives %>% 
  outlier_chk(., grouping_stats, "median_RTmsec")
## no outliers

# Check for normality
normality_learner <- learners %>% 
  normality_chk(., grouping_stats, "median_RTmsec")

normality_native <- natives %>% 
  normality_chk(., grouping_stats, "median_RTmsec")


# Create QQ plots
# Learners by milliseconds
ggqqplot(learners, "median_RTmsec", ggtheme = theme_bw(), 
         title = "QQ Plot by Target Syllable in Milliseconds by L2 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both") 

# Learners by log values
ggqqplot(learners, "median_RTlog", ggtheme = theme_bw(),
         title = "QQ Plot by Target Syllable in log by L2 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both")

# Natives by milliseconds
ggqqplot(natives, "median_RTmsec", ggtheme = theme_bw(), 
         title = "QQ Plot by Target Syllable in Milliseconds by L1 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both") 

# Natives by log values
ggqqplot(natives, "median_RTlog", ggtheme = theme_bw(),
                             title = "QQ Plot by Target Syllable in log by L1 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both")


# Run inferential statistics Learner group
# Run 3 way repeated measures anova
aov_learners <- aov_ez("partNum", "median_RTlog", learners, within = c(grouping_stats))
aov_learners
## main effect of target syllable structure
## two way interaction between matching and word status

# Regroup to run paired t-test for target syllable over all other conditions 
grouping_tarsyl <- grouping[! grouping %in% c("word_status", "word_initial_syl",
                                              "matching", "group")]
data_tarsyl_ag <- my_data %>% 
  subset(., group == "English") %>% 
  trans_long(., grouping_tarsyl)

# Significant Main Effect Exploration
# Learners t.test for target syllable structure
t.test(data_tarsyl_ag$median_RTlog ~ data_tarsyl_ag$target_syl_structure, paired = TRUE) 
## is signficant t = 2.4503, df = 26, p-value = 0.02132

# Descriptives to check direction of effect
with(data_tarsyl_ag, tapply(median_RTlog, target_syl_structure, FUN = mean)) 
## CVC faster than CV

# Interaction breakdown
# Regroup to run paired t-test for matching/mismatching over all other conditions
grouping_mat <- grouping[! grouping %in% c("word_status", "word_initial_syl",
                                           "target_syl_structure", "group")]

# Create subsets to explore interaction between matching and word status for Learners
# Nonword subset
nonwords_learners <- my_data %>%
  subset(., word_status == "nonword" & group == "English") %>% 
  trans_long(., grouping_mat)

# Create real word subset
words_learners <- my_data %>%
  subset(., word_status == "word" & group == "English") %>% 
  trans_long(., grouping_mat)


# Nonwords t.test one-tailed for matching
t.test(nonwords_learners$median_RTlog ~ nonwords_learners$matching, paired = TRUE, 
       alternative = "less") 
## is not significant t = -1.8042, df = 26, p-value = 0.0414 (uncorrected for 2 tests)
## alpha = 0.025

# Descriptives to check direction of effect
with(nonwords_learners, tapply(median_RTlog, matching, FUN = mean))
## nonwords in matching condition are responded to faster than mismatching condition

# Real words t.test ont-tailed for matching
t.test(words_learners$median_RTlog ~ words_learners$matching, paired = TRUE,
       alternative = "less")
## not significant in hypothesized direction t = 2.1855, df = 26, p-value = 0.981


#t.test(words_learners$median_RTlog ~ words_learners$matching, paired = TRUE,
#       alternative = "greater")
## One-tailed t-test 'greater' results
## t = 2.1855, df = 26, p-value = 0.01903 (uncorrected for 2 tests) 
## alpha = 0.025

# Descriptives to check direction of effect
with(words_learners, tapply(median_RTlog, matching, FUN = mean)) 
## Words in the mismatching condition repsonded to significantly faster than matching 


# Learner plots 
# Main effect of target syllable structure
l2_tar_syl_main <- afex_plot(aov_learners, 
                             x = "target_syl_structure", 
                             error = "within",
                             data_plot = FALSE,
                             mapping = c("color", "shape")) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Target Syllable Structure",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4')) +
  theme(legend.position = "none")
l2_tar_syl_main

# Interaction between matching condition and lexicality with matching condition on x-axis
l2_mat_lex_int <- afex_plot(aov_learners, 
          x = "matching", 
          trace = "word_status",
          error = "within",
          mapping = c("shape", "color", "linetype"),
          factor_levels = list(word_status = c(word = "Word", nonword = "Noword"),
                               matching = c("Matching", "Mismatching")),
          legend_title = "Lexicality",
          data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Matching Condition",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4'))
l2_mat_lex_int

# Interaction between matching condition and lexicality with lexicality conditions on x-axis
l2_lex_mat_int <- afex_plot(aov_learners, 
                        x = "word_status", 
                        trace = "matching",
                        error = "within",
                        mapping = c("shape", "color", "linetype"),
                        factor_levels = list(word_status = c(word = "Word", nonword = "Noword"),
                                             matching = c("Matching", "Mismatching")),
                        legend_title = "Condition",
                        data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Lexicality",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4'))
l2_lex_mat_int

# Plot side by side to determine which one is easier to understand data
plot_grid(l2_mat_lex_int, l2_lex_mat_int)


# Run inferential statistics Native group
# Run 3 way repeated measures anova
aov_natives <- aov_ez("partNum", "median_RTlog", natives, within = c(grouping_stats))
aov_natives
## no significant main effects, but word status trending 
## no signficant interactions

# Regroup to run paired t-test for word status over all other conditions 
grouping_lex <- grouping[! grouping %in% c("target_syl_structure", "word_initial_syl",
                                              "matching", "group")]
data_lex_ag <- my_data %>% 
  subset(., group == "Spanish") %>% 
  trans_long(., grouping_lex)

# Significant Main Effect Exploration
# Natives t.test for word status
t.test(data_lex_ag$median_RTlog ~ data_lex_ag$word_status, paired = TRUE)
## is significant t = 2.2105, df = 17, p-value = 0.04106

# Descriptives to check direction of effect
with(data_lex_ag, tapply(median_RTlog, word_status, FUN = mean))
## words responded to faster than nonwords


# Native plots
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
ggsave('learners_descriptive_data.png', bxp_learners, 'png', out_dir)
ggsave('natives_descriptive_data.png', bxp_natives, 'png', out_dir)
ggsave('learners_tarsyl_main.png', l2_tar_syl_main, 'png', out_dir)
ggsave('learners_lex_mat_int.png', l2_lex_mat_int, 'png', out_dir)
ggsave('natives_lex_main.png', l1_lex_main, 'png', out_dir)
