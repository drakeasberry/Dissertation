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
grouping_stats <- c("word_initial_syl", "matching", "word_status")

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
  ggplot(aes(x = word_initial_syl,
             y = median_RTmsec,
             color = mat_new)) +
  geom_boxplot(fill = NA, position = position_dodge(1)) +
  geom_violin(fill = NA, position = position_dodge(1)) +
  facet_wrap(. ~ wd_new) +
  labs(title = "L2 Spanish by Word Initial Syllable",
       x = "Word Initial Syllable Structure",
       y = "Reaction Time (msec)") +
  scale_color_manual(name = "Condition", values = c('darkorchid4', 'goldenrod4'))
bxp_learners

# Natives
bxp_natives <- natives %>% 
  mutate(wd_new = factor(word_status, levels = c("word", "nonword"),
                         labels = c("Word", "Nonword")),
         mat_new = factor(matching, levels = c("matching", "mismatching"),
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
#outlier_data <- my_data_long %>% 
#  outlier_chk(., grouping_stats, "median_RTmsec")

outlier_learner <- learners %>% 
  outlier_chk(., grouping_stats, "median_RTmsec")

outlier_native <- natives %>% 
  outlier_chk(., grouping_stats, "median_RTmsec")

# Check for normality
normality_learner <- learners %>% 
  normality_chk(., grouping_stats, "median_RTmsec")

normality_native <- natives %>% 
  normality_chk(., grouping_stats, "median_RTmsec")


# Create QQ plots
# Learners by milliseconds
ggqqplot(learners, "median_RTmsec", ggtheme = theme_bw(), 
         title = "QQ Plot by Word Initial Syllable in Milliseconds by L2 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both") 

# Learners by log values
ggqqplot(learners, "median_RTlog", ggtheme = theme_bw(),
         title = "QQ Plot by Word Initial Syllable in log by L2 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both")

# Natives by milliseconds
ggqqplot(natives, "median_RTmsec", ggtheme = theme_bw(), 
         title = "QQ Plot by Word Initial Syllable in Milliseconds by L1 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both") 

# Natives by log values
ggqqplot(natives, "median_RTlog", ggtheme = theme_bw(),
         title = "QQ Plot by Word Initial Syllable in log by L1 Spanish Speakers") +
  facet_grid(word_initial_syl + matching ~ word_status, labeller = "label_both")


# Run inferential statistics Learner group
# Run 3 way repeated measures anova
aov_learners <- aov_ez("partNum", "median_RTlog", learners, within = c(grouping_stats))
aov_learners
## no significant main effects
## two way interaction between word initial syllable and matching
## two way interaction between matching and word status


# Significant Main Effect Exploration
## none to explore

# Interaction breakdown
# Regroup to run paired t-test for matching/mismatching over all other conditions
grouping_mat <- grouping[! grouping %in% c("word_status", "word_initial_syl",
                                           "target_syl_structure", "group")]

# Create subsets to explore interaction between word initial syllable and matching for Learners
# CV subset
cv_learners <- my_data %>% 
  subset(., word_initial_syl == "CV" & group == "English") %>% 
  trans_long(., grouping_mat)

# CVC subset
cvc_learners <- my_data %>% 
  subset(., word_initial_syl == "CVC" & group == "English") %>% 
  trans_long(., grouping_mat)

# CV syllable t.test
t.test(cv_learners$median_RTlog ~ cv_learners$matching, paired = TRUE,
       alternative = "less") 
## not significant in hypothesized direction

# Descriptives to check direction of effect
with(cv_learners, tapply(median_RTlog, matching, FUN = mean))
## CV word initial syllables mismatching the target syllable are responded to faster than matching

# CVC sylable t.test
t.test(cvc_learners$median_RTlog ~ cvc_learners$matching, paired = TRUE,
       alternative = "less") 
## is not significant

# Descriptives to check direction of effect
with(cvc_learners, tapply(median_RTlog, matching, FUN = mean)) 
## no direction significance, but trending in expected direction


# Create subsets to explore interaction between matching and word status for Learners
# Nonword subset
nonwords_learners <- my_data %>% 
  subset(., word_status == "nonword" & group == "English") %>% 
  trans_long(., grouping_mat)

# Create real word subset
words_learners <- my_data %>% 
  subset(., word_status == "word" & group == "English") %>% 
  trans_long(., grouping_mat)

# Nonwords t.test
# Two-tailed t-test 
t.test(nonwords_learners$median_RTlog ~ nonwords_learners$matching, paired = TRUE)
## not significant

# One-tailed t-test
t.test(nonwords_learners$median_RTlog ~ nonwords_learners$matching, paired = TRUE,
       alternative = "less") 
## is significant
## we are only looking in one direction at 95% CI 

# Descriptives to check direction of effect
with(nonwords_learners, tapply(median_RTlog, matching, FUN = mean))
## Nonwords in matching condition responded to faster than those in the mismatching condition

# Real words t.test
t.test(words_learners$median_RTlog ~ words_learners$matching, paired = TRUE, 
       alternative = "less") 
## not significant in hypothesized direction

# Descriptives to check direction of effect
with(words_learners, tapply(median_RTlog, matching, FUN = mean)) 
## Mismatching cond faster than matching


# Estimated Marginal Means
# get tabled results of estimated marginal means
wdsyl_mat_int <- emmeans(aov_learners, pairwise ~ word_initial_syl:matching) 
wdsyl_mat_int

mat_wdstatus_int <- emmeans(aov_learners, pairwise ~ matching:word_status) 
mat_wdstatus_int


# Learner plots 
# Interaction between matching condition and lexicality with matching condition on x-axis
l2_wdsyl_mat_int <- afex_plot(aov_learners, 
                            x = "matching", 
                            trace = "word_initial_syl",
                            error = "within",
                            mapping = c("shape", "color", "linetype"),
                            factor_levels = list(matching = c("Matching", "Mismatching")),
                            legend_title = "Word Initial Syllable",
                            data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Matching Condition",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4'))
l2_wdsyl_mat_int

# Interaction between matching condition and lexicality with lexicality conditions on x-axis
l2_mat_wdsyl_int <- afex_plot(aov_learners, 
                            x = "word_initial_syl", 
                            trace = "matching",
                            error = "within",
                            mapping = c("shape", "color", "linetype"),
                            factor_levels = list(matching = c("Matching", "Mismatching")),
                            legend_title = "Condition",
                            data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Word Initial Syllable",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4'))
l2_mat_wdsyl_int

# Plot side by side to determine which one is easier to understand data
plot_grid(l2_wdsyl_mat_int, l2_mat_wdsyl_int)


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
## no significant main effect (Lexicality trending)
## no significant interactions


# Significant Main Effect Exploration
# Regroup to run paired t-test for word status over all other conditions 
grouping_lex <- grouping[! grouping %in% c("target_syl_structure", "word_initial_syl",
                                           "matching", "group")]
data_lex_ag <- my_data %>% 
  subset(., group == "Spanish") %>% 
  trans_long(., grouping_lex)

##################### Start here again #######################
#nw_wd <- compare_means(median_RTlog ~ word_status, data = data_lex_ag, paired = TRUE)
#data_lex_ag %>% 
#  ggplot(aes(x = word_status,
#             y = median_RTlog)) +
#  geom_boxplot() + 
#  stat_compare_means(comparisons = nw_wd)

# Natives t.test for word status (trending)
t.test(data_lex_ag$median_RTlog ~ data_lex_ag$word_status, paired = TRUE)
## is significant

# Descriptives to check direction of effect
with(data_lex_ag, tapply(median_RTlog, word_status, FUN = mean))
## words responded to faster than nonwords


# Estimated Marginal Means
# get tabled results of estimated marginal means
lex_main <- emmeans(aov_natives, pairwise ~ word_status) 
lex_main


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
rm(my_data, my_data_long, learners, natives, words_learners, nonwords_learners, 
   cvc_learners, cv_learners)

# Remove checks and unused plots
rm(l2_mat_lex_int, l2_wdsyl_mat_int, normality_learner, normality_native, 
   outlier_learner, outlier_native)

out_dir = 'analyze_data/output/figures/by_word/'

# Save tabled data
# https://tex.stackexchange.com/questions/481802/reporting-r-results-in-latex

# Save plots
ggsave('learners_descriptive_data.png', bxp_learners, 'png', out_dir)
ggsave('natives_descriptive_data.png', bxp_natives, 'png', out_dir)
ggsave('learners_wdsyl_mat_int.png', l2_mat_wdsyl_int, 'png', out_dir)
ggsave('learners_lex_mat_int.png', l2_lex_mat_int, 'png', out_dir)
ggsave('natives_lex_main.png', l1_lex_main, 'png', out_dir)
