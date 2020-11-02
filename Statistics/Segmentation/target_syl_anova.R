#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(readr)
library(emmeans)
library(ggplot2)
library(cowplot)

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
# Adds columns for median of RT in msec and log
my_data_long <- trans_long(my_data, grouping) 


# Create subgroups for Spanish learners and native speakers
learners <- part_group(my_data_long, 'English')
natives <- part_group(my_data_long, 'Spanish')


# Group data by target syllable structure, matching condition, and word status, 
grouping_stats <- c("target_syl_structure", "matching", "word_status")

# Then summary statistics for reaction time
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
bxp_learners <- ggboxplot(learners, "target_syl_structure", "median_RTmsec",
                              color = "matching", 
                              palette = "jco",
                              title = "L2 Spanish by Target Syllable",
                              xlab = "Target Syllable Structure",
                              ylab = "Reaction Time (msec)",
                              facet.by = "word_status") %>% 
  print()

# Natives
bxp_natives <- ggboxplot(natives, "target_syl_structure", "median_RTmsec",
                             color = "matching", 
                             palette = "jco",
                             title = "L1 Spanish by Target Syllable",
                             xlab = "Target Syllable Structure",
                             ylab = "Reaction Time (msec)",
                             facet.by = "word_status") %>% 
  print()


# Check for outliers
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

# Natives by milliseconds
ggqqplot(natives, "median_RTlog", ggtheme = theme_bw(),
                             title = "QQ Plot by Target Syllable in log by L1 Spanish Speakers") +
  facet_grid(target_syl_structure + matching ~ word_status, labeller = "label_both")


# Run inferential statistics Learner group
# Run 3 way repeated measures anova
aov_learners <- aov_ez("partNum", "median_RTlog", learners, within = c(grouping_stats))
aov_learners
## main effect of target syllable structure
## two way interaction between matching and word status
 
# Significant Main Effect Exploration
# Learners t.test for target syllable structure
t.test(learners$median_RTlog ~ learners$target_syl_structure, paired = TRUE) 
## signficant

# Descriptives to check direction of effect
with(learners, tapply(median_RTlog, target_syl_structure, FUN = mean)) 
## CVC faster than CV

# Interaction breakdown
# Create subsets to explore interaction between matching and word status for Learners
# Nonword subset
nonwords_learners <- learners %>% 
  subset(., word_status == "nonword")

# Create real word subset
words_learners <- learners %>% 
  subset(., word_status == "word")


# Nonwords t.test
t.test(nonwords_learners$median_RTlog ~ nonwords_learners$matching, paired = TRUE) 
## not significant

# Descriptives to check direction of effect
with(nonwords_learners, tapply(median_RTlog, matching, FUN = mean))


# Real words t.test
t.test(words_learners$median_RTlog ~ words_learners$matching, paired = TRUE) 
## is significant

# Descriptives to check direction of effect
with(words_learners, tapply(median_RTlog, matching, FUN = mean)) 
## Mismatching cond faster than matching


# Estimated Marginal Means
# get tabled results of estimated marginal means
tar_syl_main <- emmeans(aov_learners, pairwise ~ target_syl_structure) 
tar_syl_main

mat_wdstatus_int <- emmeans(aov_learners, pairwise ~ matching:word_status) 
mat_wdstatus_int


# Learner plots 
# Main effect of target syllable structure
l2_tar_syl_main <- afex_plot(aov_learners, 
                                x = "target_syl_structure", 
                                error = "within",
                                factor_levels = list(word_status = c(word = "Word", nonword = "Noword")),
                                data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Target Syllable Structure",
       y = "Reaction Time log")
print(l2_tar_syl_main)

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
       y = "Reaction Time log")  
print(l2_mat_lex_int)

# Interaction between matching condition and lexicality with lexicality conditions on x-axis
l2_lex_mat_int <- afex_plot(aov_learners, 
                        x = "word_status", 
                        trace = "matching",
                        error = "within",
                        mapping = c("shape", "color", "linetype"),
                        factor_levels = list(word_status = c(word = "Word", nonword = "Noword"),
                                             matching = c("Matching", "Mismatching")),
                        legend_title = "Matching",
                        data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Lexicality",
       y = "Reaction Time log")
print(l2_lex_mat_int)

# Plot side by side to determine which one is easier to understand data
plot_grid(l2_mat_lex_int, l2_lex_mat_int)


# Run inferential statistics Native group
# Run 3 way repeated measures anova
aov_natives <- aov_ez("partNum", "median_RTlog", natives, within = c(grouping_stats))
aov_natives
## main effect of word status
## no signficant interactions

# Significant Main Effect Exploration
# Natives t.test for word status
t.test(natives$median_RTlog ~ natives$word_status, paired = TRUE)
## is significant

# Descriptives to check direction of effect
with(natives, tapply(median_RTlog, word_status, FUN = mean))
## words responded to faster than nonwords


# Estimated Marginal Means
# get tabled results of estimated marginal means
wd_status_main <- emmeans(aov_natives, pairwise ~ word_status) 
wd_status_main


# Native plots
# Main effect of lexicality
l1_lexicality_main <- afex_plot(aov_natives, 
                                x = "word_status", 
                                error = "within",
                                factor_levels = list(word_status = c(word = "Word", 
                                                                     nonword = "Noword")),
                                data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L1 Spanish",
       x = "Lexicality",
       y = "Reaction Time log")
print(l1_lexicality_main)

#native_congruency <- afex_plot(aov_natives, 
#                                x = "word_status", 
#                                trace = "matching",
#                                error = "within",
#                                mapping = c("shape", "color", "linetype"),
#                                factor_levels = list(word_status = c(word = "Word", nonword = #"Noword"),
#                                                     matching = c("Matching", "Mismatching")),
#                                legend_title = "Matching",
#                                data_plot = FALSE) +
#  labs(title = "Estimated Marginal Means L1 Spanish",
#       x = "Lexicality",
#       y = "Reaction Time log")
#print(native_congruency)

# Remove dataframes following analysis
rm(my_data, my_data_long, learners, natives, words_learners, nonwords_learners)

# Remove checks and unused plots
rm(l2_mat_lex_int, normality_learner, normality_native, outlier_learner, outlier_native)
