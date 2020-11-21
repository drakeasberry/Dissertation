#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(tidyverse)
library(ggplot2)
library(kableExtra)
library(qwraps2)
library(emmeans)

# Soruce Scripts containing functions
source("../../Scripts_Dissertation/segmentation_rm_anova_script.R")


# read in the data
my_data_long <- read_csv('analyze_data/output/data_long.csv')

my_data_long <- my_data_long %>% 
  convert_as_factor(partNum, group, syl_structure)


# Group data by target syllable structure, matching condition, and word status, 
grouping_stats <- c("syl_structure", "group")

# Summary statistics for reaction time
# Proportion Correct
my_data_long %>% 
  summary_stats(., grouping_stats, "correct", "mean_sd")

# Logit
my_data_long %>% 
  summary_stats(., grouping_stats, "logit", "mean_sd")


# Visualize Descriptive Data
# Proportion data
my_data_long %>% 
  summary_stats(., grouping_stats, "correct", "mean_sd") %>% 
  ggplot(aes(x = group,
             y = mean,
             fill = syl_structure)) +
  geom_bar(stat = "identity", position = 'dodge') +
  geom_errorbar(aes(ymin = mean - sd, 
                    ymax = mean + sd), 
                width = 0.2, 
                alpha = 0.9, 
                position = position_dodge(width = 0.9)) +
  labs(title = "Percent Correct",
       x = "Language Group",
       y = "") +
  scale_fill_manual(name = "Syllable Structure", values = c('darkorchid4', 'goldenrod4')) +
  theme_minimal()


# Logit data of correct responses
my_data_long %>% 
  summary_stats(., grouping_stats, "logit", "mean_sd") %>% 
  ggplot(aes(x = group,
             y = mean,
             fill = syl_structure)) +
  geom_bar(stat = "identity", position = 'dodge') +
  geom_errorbar(aes(ymin = mean - sd, 
                    ymax = mean + sd), 
                width = 0.2, 
                alpha = 0.9, 
                position = position_dodge(width = 0.9)) +
  labs(title = "Correct Responses (logit)",
       x = "Language Group",
       y = "") +
  scale_fill_manual(name = "Syllable Structure", values = c('darkorchid4', 'goldenrod4')) +
  theme_minimal()

 
# Check for outliers
# Check pooled data
outlier_data <- my_data_long %>% 
  outlier_chk(., grouping_stats, "logit")

# Plot data 
boxplot(my_data_long$correct)
boxplot(my_data_long$logit)
## no outliers visible


# Check for normality
normality_all <- my_data_long %>% 
  normality_chk(., grouping_stats, "correct")


# Run inferential statistics Learner group
# Run repeated measures anova
aov <- aov_ez("partNum", "logit", my_data_long, within = 'syl_structure', between = 'group')
aov


# Significant Main Effect Exploration
# t.test for group main effect
t.test(my_data_long$logit ~ my_data_long$group, paired = FALSE)


# t.test for syllable structure main effect
t.test(my_data_long$logit ~ my_data_long$syl_structure, paired = TRUE)

# Descriptives to check direction of effect
with(my_data_long, tapply(logit, syl_structure, FUN = mean))
# CV are less accurate than CVC syllable


# Main effect of syllable structure
syl_main <- afex_plot(aov, 
                             x = "syl_structure", 
                             error = "within",
                             data_plot = FALSE,
                             mapping = c("color", "shape")) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Syllable Structure",
       y = "Reaction Time (log)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4')) +
  theme(legend.position = "none")
syl_main


# Interaction between matching condition and lexicality with lexicality conditions on x-axis
grp_syl_int <- afex_plot(aov, 
                            x = "syl_structure", 
                            trace = "group",
                            error = "between",
                            mapping = c("shape", "color", "linetype"),
                            legend_title = "Native Language",
                            data_plot = FALSE) +
  labs(title = "Estimated Marginal Means L2 Spanish",
       x = "Syllable Structure",
       y = "Response Correct (logit)") +
  scale_color_manual(values = c('darkorchid4', 'goldenrod4'))
grp_syl_int



# Build summary table
descriptives <-
  list("Language Dominance" = 
         list("mean (sd)" = ~ qwraps2::mean_sd(lang_dominance)),
       "English Vocabulary Size" =
         list("mean (sd)" = ~ qwraps2::mean_sd(lextale_eng_correct)),
       "Spanish Vocabulary Size" =
         list("mean (sd)" = ~ qwraps2::mean_sd(lextale_esp_correct))
  )     


# Create latex formattable table
by_lang <- summary_table(dplyr::group_by(demo_data, group),dominance_summary)
print(by_lang)


# Create image of tabled results
by_lang %>% 
  kbl(caption = "Descriptives") %>%
  kable_styling() %>% 
  pack_rows("Language Dominance", 1, 1) %>% 
  pack_rows("English Vocabulary Size", 2, 2) %>%
  pack_rows("Spanish Vocabulary Size", 3, 3) %>%
  kable_classic(full_width = F, html_font = "Cambria")


