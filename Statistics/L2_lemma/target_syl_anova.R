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
grouping_stats <- c("target_syl_structure", "matching", "word_status")

# Summary statistics for reaction time
# Reaction time in miliseconds
learners %>% 
  summary_stats(., grouping_stats, "median_RTmsec", "mean_sd")

# Reaction time after log transformation
learners %>% 
  summary_stats(., grouping_stats, "median_RTlog", "mean_sd")


# learners
bxp_learners <- learners %>% 
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
  labs(title = "L2 Spanish by Target Syllable",
       x = "Target Syllable Structure",
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
         title = "QQ Plot by Target Syllable in Milliseconds by L2 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both") 

# learners by log values
ggqqplot(learners, "median_RTlog", ggtheme = theme_bw(),
         title = "QQ Plot by Target Syllable in log by L2 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both")


# Run inferential statistics Native group
# Run 3 way repeated measures anova
aov_learners <- aov_ez("partNum", "median_RTlog", learners, within = c(grouping_stats))
aov_learners
## no significant main effects, but matching is trending
## two way interaction between target syllable structure and matching condition
## two way interaction between target syllable structure and word status


# Significant Main Effect Exploration
## none to explore (explore matching trend)
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


# Estimated Marginal Means
# get tabled results of estimated marginal means
mat_main <- emmeans(aov_learners, pairwise ~ matching) 
mat_main


# Native plots
# Main effect of matching condition
l1_mat_main <- afex_plot(aov_learners, 
                         x = "matching", 
                         error = "within",
                         factor_levels = list(matching = c(match = "Matching", 
                                                           mismatch = "Mismatching")),
                         data_plot = FALSE,
                         mapping = c("color", "shape")) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Matching Condition",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4')) +
  theme(legend.position = "none")
l1_mat_main


# Interaction breakdown
# Create subsets to explore interaction between target initial syllable and matching
# CV subset
cv_learners <- my_data %>% 
  subset(., target_syl_structure == "CV") %>% 
  trans_long(., grouping_mat)

# CVC subset
cvc_learners <- my_data %>% 
  subset(., target_syl_structure == "CVC") %>% 
  trans_long(., grouping_mat)


# CV syllable t.test
t.test(cv_learners$median_RTlog ~ cv_learners$matching, paired = TRUE) 
## is significant

# CVC sylable t.test one-tailed
t.test(cv_learners$median_RTlog ~ cv_learners$matching, paired = TRUE, alternative = "less")
##is significant

# Descriptives to check direction of effect
with(cv_learners, tapply(median_RTlog, matching, FUN = mean))
## CV target syllables matching the word inital syllable are responded to faster than mismatching


# CVC sylable t.test
t.test(cvc_learners$median_RTlog ~ cvc_learners$matching, paired = TRUE) 
## is significant

# CVC sylable t.test one-tailed
t.test(cvc_learners$median_RTlog ~ cvc_learners$matching, paired = TRUE, alternative = "less")
## not significant in hypothesized direction

# Descriptives to check direction of effect
with(cvc_learners, tapply(median_RTlog, matching, FUN = mean)) 
## CVC target syllables matching the word inital syllable are responded to slower than mismatching


# Create subsets to explore interaction between target syllable structure and word status
grouping_tarsyl <- grouping[! grouping %in% c("word_status", "word_initial_syl",
                                           "matching", "group")]

# Nonword subset
nonwords_learners <- my_data %>% 
  subset(., word_status == "nonword") %>% 
  trans_long(., grouping_tarsyl)

# Create real word subset
words_learners <- my_data %>% 
  subset(., word_status == "word") %>% 
  trans_long(., grouping_tarsyl)

# Nonwords t.test
t.test(nonwords_learners$median_RTlog ~ nonwords_learners$target_syl_structure, paired = TRUE) 
## not significant

# Descriptives to check direction of effect
with(nonwords_learners, tapply(median_RTlog, target_syl_structure , FUN = mean))
## CVC faster than CV target syllable for nonwords, but not signficantly so

# Real words t.test
t.test(words_learners$median_RTlog ~ words_learners$target_syl_structure, paired = TRUE) 
## not significant

# Descriptives to check direction of effect
with(words_learners, tapply(median_RTlog, target_syl_structure, FUN = mean)) 
## CV faster than CVC target syllable for words, but not significantly so

# Regroup to run paired t-test for word status over all other conditions 
grouping_lex <- grouping[! grouping %in% c("target_syl_structure", "word_initial_syl",
                                           "matching", "group")]

# Create subsets to explore interaction between target initial syllable and word status
# CV subset
cv_learners_lex <- my_data %>% 
  subset(., target_syl_structure == "CV") %>% 
  trans_long(., grouping_lex)

# CVC subset
cvc_learners_lex <- my_data %>% 
  subset(., target_syl_structure == "CVC") %>% 
  trans_long(., grouping_lex)


# CV syllable t.test
t.test(cv_learners_lex$median_RTlog ~ cv_learners_lex$word_status, paired = TRUE) 
## not significant

# Descriptives to check direction of effect
with(cv_learners_lex, tapply(median_RTlog, word_status, FUN = mean))
## CV target syllables are responded to faster for words than nonwords, but not significantly so


# CVC sylable t.test
t.test(cvc_learners_lex$median_RTlog ~ cvc_learners_lex$word_status, paired = TRUE) 
## not significant

# Descriptives to check direction of effect
with(cvc_learners_lex, tapply(median_RTlog, word_status, FUN = mean)) 
## CVC target syllables are responded to faster for nonwords than words, but not significantly so


# Create subsets to explore interaction between matching and word status (trending)
# Nonword subset
nonwords_learners_mat <- my_data %>%
  subset(., word_status == "nonword") %>% 
  trans_long(., grouping_mat)

# Create real word subset
words_learners_mat <- my_data %>%
  subset(., word_status == "word") %>% 
  trans_long(., grouping_mat)


# Nonwords t.test one-tailed for matching
t.test(nonwords_learners_mat$median_RTlog ~ nonwords_learners_mat$matching, paired = TRUE, 
       alternative = "less") 
## is significant

# Descriptives to check direction of effect
with(nonwords_learners_mat, tapply(median_RTlog, matching, FUN = mean))
## nonwords in matching condition are responded to faster than mismatching condition

# Real words t.test ont-tailed for matching
t.test(words_learners_mat$median_RTlog ~ words_learners_mat$matching, paired = TRUE,
       alternative = "less") 
## not significant

# Descriptives to check direction of effect
with(words_learners_mat, tapply(median_RTlog, matching, FUN = mean)) 
## Words in the matching condition repsonded to faster than nonmatching, but not significantly so


# Estimated Marginal Means
# get tabled results of estimated marginal means
tarsyl_mat_int <- emmeans(aov_learners, pairwise ~ target_syl_structure:matching) 
tarsyl_mat_int

tarsyl_wdstatus_int <- emmeans(aov_learners, pairwise ~ target_syl_structure:word_status) 
tarsyl_wdstatus_int

wdstatus_mat_int <- emmeans(aov_learners, pairwise ~ matching:word_status) 
wdstatus_mat_int

# Learner plots 
# Interaction between matching condition and target syllable with matching condition on x-axis
l2_tarsyl_mat_int <- afex_plot(aov_learners, 
                              x = "matching", 
                              trace = "target_syl_structure",
                              error = "within",
                              mapping = c("shape", "color", "linetype"),
                              factor_levels = list(matching = c("Matching", "Mismatching")),
                              legend_title = "Target Syllable",
                              data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Matching Condition",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4'))
l2_tarsyl_mat_int

# Interaction between matching condition and target syllable with target syllable conditions on x-axis
l2_mat_tarsyl_int <- afex_plot(aov_learners, 
                              x = "target_syl_structure", 
                              trace = "matching",
                              error = "within",
                              mapping = c("shape", "color", "linetype"),
                              factor_levels = list(matching = c("Matching", "Mismatching")),
                              legend_title = "Condition",
                              data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Target Syllable",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4'))
l2_mat_tarsyl_int

# Plot side by side to determine which one is easier to understand data
plot_grid(l2_tarsyl_mat_int, l2_mat_tarsyl_int)


# Interaction between target syllable and lexicality with target syllable on x-axis
l2_tarsyl_lex_int <- afex_plot(aov_learners, 
                            x = "target_syl_structure", 
                            trace = "word_status",
                            error = "within",
                            mapping = c("shape", "color", "linetype"),
                            factor_levels = list(word_status = c(word = "Word", nonword = "Noword")),
                            legend_title = "Lexicality",
                            data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Target Syllable",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4'))
l2_tarsyl_lex_int

# Interaction between target syllable and lexicality with lexicality conditions on x-axis
l2_lex_tarsyl_int <- afex_plot(aov_learners, 
                            x = "word_status", 
                            trace = "target_syl_structure",
                            error = "within",
                            mapping = c("shape", "color", "linetype"),
                            factor_levels = list(word_status = c(word = "Word", nonword = "Noword")),
                            legend_title = "Target Syllable",
                            data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Lexicality",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4'))
l2_lex_tarsyl_int

# Plot side by side to determine which one is easier to understand data
plot_grid(l2_tarsyl_lex_int, l2_lex_tarsyl_int)

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


# Remove temporary data variables in environment
# Remove dataframes following analysis
rm(my_data, my_data_long, learners, words_learners, nonwords_learners,
   cv_learners, cvc_learners)

# Remove checks and unused plots
rm(l2_tarsyl_mat_int, l2_lex_tarsyl_int, normality_learner, outlier_learner)


# Save all analyses
out_dir = 'analyze_data/output/figures/by_target/'

# Save tabled data
# https://tex.stackexchange.com/questions/481802/reporting-r-results-in-latex

# Save plots
ggsave('learners_descriptive_data.png', bxp_learners, 'png', out_dir)
ggsave('learners_mat_tarsyl_int.png', l2_mat_tarsyl_int, 'png', out_dir)
ggsave('learners_tarsyl_lex_int.png', l2_tarsyl_lex_int, 'png', out_dir)
