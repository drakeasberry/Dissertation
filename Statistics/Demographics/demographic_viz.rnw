#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(tidyverse)
library(psych)
library(lattice)


# Read csv file for Izura LexTALE-ESP calculations
izura_score <- read_csv('analyze_data/output/izura_scores.csv')

# Read in group to participant mapping
group_map <- read_csv('../../Scripts_Dissertation/participant_group_map.csv')

# Add experimental group column
izura_score <- izura_score %>% 
  left_join(group_map, by = 'partNum')

# Counts by participant group
izura_score %>% 
  group_by(group) %>% 
  count()

# All participants Lextale-Esp distribution plots
densityplot(~izura_score, 
            data = izura_score, 
            main = 'Density plot of All participants') 
histogram(~izura_score, 
          data = izura_score, 
          main = 'All participants collected') 

# All participants Lextale-Esp descriptive statistics 
all <- describe(izura_score$izura_score) %>% 
  mutate(vars = "All participants") %>% 
  rename(group = vars)


# L1 Spanish participants Lextale-Esp distribution plots
# Create subset Spanish natives
l1_spanish <- izura_score %>% 
  subset(., group == "Spanish" | group == "Monolingual Spanish")

densityplot(~izura_score, 
            data = l1_spanish, 
            main = 'Density plot of L1 Spanish participants') 
histogram(~izura_score, 
          data = l1_spanish, 
          main = 'L1 Spanish participants collected')

# L1 Spanish participants Lextale-Esp descriptive statistics 
l1 <- describe(l1_spanish$izura_score) %>% 
  mutate(vars = "Native Spanish") %>% 
  rename(group = vars)


# L1 Spanish bilingual participants Lextale-Esp distribution plots
# Create subset Spanish natives bilingual
l1_bi_spanish <- izura_score %>% 
  subset(., group == "Spanish")

densityplot(~izura_score, 
            data = l1_bi_spanish, 
            main = 'Density plot of L1 Spanish bilingual participants') 
histogram(~izura_score, 
          data = l1_bi_spanish, 
          main = 'L1 Spanish bilingual participants collected')

# L1 Spanish bilingual participants Lextale-Esp descriptive statistics 
l1_bi <- describe(l1_bi_spanish$izura_score) %>% 
  mutate(vars = "Native Spanish Bilingual") %>% 
  rename(group = vars)


# L1 Spanish monolingual participants Lextale-Esp distribution plots
# Create subset Spanish natives monolingual
l1_mono_spanish <- izura_score %>% 
  subset(., group == "Monolingual Spanish")

densityplot(~izura_score, 
            data = l1_mono_spanish, 
            main = 'Density plot of L1 Spanish monolingual participants') 
histogram(~izura_score, 
          data = l1_mono_spanish, 
          main = 'L1 Spanish monolingual participants collected')

# L1 Spanish monolingual participants Lextale-Esp descriptive statistics 
l1_mono <- describe(l1_mono_spanish$izura_score) %>% 
  mutate(vars = "Native Spanish Monolingual") %>% 
  rename(group = vars)


# L2 Spanish participants Lextale-Esp distribution plots
# Create subset English natives
l2_spanish <- izura_score %>% 
  subset(., group == "English" | group == "L2 Learner")

densityplot(~izura_score, 
            data = l2_spanish, 
            main = 'Density plot of L2 Spanish participants') 
histogram(~izura_score, 
          data = l2_spanish, 
          main = 'L2 Spanish participants collected')

# L2 Spanish participants Lextale-Esp descriptive statistics 
l2 <- describe(l2_spanish$izura_score) %>% 
  mutate(vars = "Native English") %>% 
  rename(group = vars)


# Create table of group statistics
table_descriptives <- do.call('rbind', list(all, l1, l1_mono, l1_bi, l2))

# Remove unnecessary objects
rm(all, l1, l1_mono, l1_bi, l2)
