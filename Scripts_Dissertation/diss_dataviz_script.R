#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(readr)
library(tidyverse)
library(ggpubr)
library(afex)
library(ggplot2)

# Create 'not in' function
'%ni%' <- Negate('%in%')

# Create Color Scheme
plt_color_2 <- c('darkorchid4', 'goldenrod4')

# add significance asterisks to ANOVA table
aov_manu <- function(data){
  data %>% 
    # This creates a column name that is equal to a one space, not ideal but working
    mutate(` ` = case_when(`Pr(>F)`<0.001 ~ '***',
                           `Pr(>F)`<0.01 ~ '**',
                           `Pr(>F)`<0.05 ~ '*'))
}

# Descriptives box, point, violin plot 
descriptive_plot <- function(data, x_data, y_data){
  data %>%
    group_by(!!sym(x_data)) %>% 
    add_count() %>% 
    mutate(labels = ifelse(!!sym(y_data) == max(!!sym(y_data)), paste0('n = ', n), '')) %>% 
    ggplot(aes(x = !!sym(x_data),
               y = !!sym(y_data))) +
    geom_boxplot(color = 'darkorchid4', 
                 width = 0.5,
                 outlier.shape = 8, 
                 outlier.size = 2) +
    
    geom_violin(color ='goldenrod4', 
                fill = NA) +
    geom_jitter(width = 0.1) +
    theme_light()
}


# Create Vocabulary Difference box, point, violin plot Descriptives
vocab_diff_plt <- function(data, x_data, y_data){
  data %>% 
    descriptive_plot(., x_data, y_data) +
    geom_text(aes(label=labels, y = !!sym(y_data) + 8)) +
    ggtitle("Difference in L1 and L2 Vocabulary Size") +
    xlab("L1 Language") +
    ylab("Vocabulary Difference \nEN-SP")
}


# Language Dominance box, point, violin plot Descriptives
language_dominance <- function(data, x_data, y_data){
  data %>% 
    descriptive_plot(., x_data, y_data) +
    geom_text(aes(label=labels, y = !!sym(y_data) + 20)) +
    ggtitle("Language Dominance") +
    xlab("L1 Language") +
    ylab("Binlingual Language Profile \nDominance Score")
}


# English Vocabulary Size box, point, violin plot Descriptives
eng_lextale <- function(data, x_data, y_data){
  data %>% 
    descriptive_plot(., x_data, y_data) +
    geom_text(aes(label=labels, y = !!sym(y_data) + 5)) +
    ggtitle("English Vocabulary Size") +
    xlab("L1 Language") +
    ylab("English Vocabulary \n% correct")
}


# Spanish Vocabulary Size box, point, violin plot Descriptives
esp_lextale <- function(data, x_data, y_data){
  data %>% 
    descriptive_plot(., x_data, y_data) +
    geom_text(aes(label=labels, y = !!sym(y_data) + 5)) +
    ggtitle("Spanish Vocabulary Size") +
    xlab("L1 Language") +
    ylab("Spanish Vocabulary \n% correct")
}


# Izura box, point, violin plot Descriptives
izura <- function(data, x_data, y_data){
  data %>% 
    descriptive_plot(., x_data, y_data) +
    geom_text(aes(label=labels, y = !!sym(y_data) + 7)) +
    ggtitle("Spanish Vocabulary Size") +
    xlab("L1 Language") +
    ylab("Izura Score")
}

# Density plots
density <- function(data, x_data, group){
  grp_data <- data %>% 
    group_by(group) %>% 
    summarise(grp_mean = mean(izura_score)) 
    
  data %>% 
    ggplot(., aes(x=!!sym(x_data),
                  fill = !!sym(group),
                  color = !!sym(group))) +
    geom_density(aes(linetype = !!sym(group)), outline.type = "full", alpha = .3) +
    geom_vline(data = grp_data, aes(xintercept = grp_mean, color = !!sym(group)), linetype = "dashed") +
    coord_cartesian(xlim = c(min(eligible_izura_score$izura_score)-10,
                             max(eligible_izura_score$izura_score)+10)) +
    scale_color_manual(name = "Group", values = c('darkorchid4', 'goldenrod4')) +
    scale_fill_manual(name = "Group", values = c('darkorchid4', 'goldenrod4')) +
    scale_linetype_manual(name = "Group", values = c('solid', 'dotted')) +
    theme_light()
}

# Histogram plots
histo <- function(data, x_data, group){
  grp_data <- data %>% 
    group_by(group) %>% 
    summarise(grp_mean = mean(izura_score)) 
  
  data %>% 
    ggplot(., aes(x=!!sym(x_data),
                  fill = !!sym(group),
                  color = !!sym(group))) +
    geom_histogram(aes(linetype = !!sym(group)),binwidth = 5, alpha = .3, position = 'identity') +
    #geom_vline(data = grp_data, aes(xintercept = grp_mean, color = !!sym(group)), linetype = "dashed") +
    coord_cartesian(xlim = c(min(eligible_izura_score$izura_score)-10,
                             max(eligible_izura_score$izura_score)+10)) +
    scale_color_manual(name = "Group", values = c('darkorchid4', 'goldenrod4')) +
    scale_fill_manual(name = "Group", values = c('darkorchid4', 'goldenrod4')) +
    scale_linetype_manual(name = "Group", values = c('solid', 'dotted')) +
    theme_light()
}