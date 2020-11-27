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

# Descriptives box, point, violin plot 
descriptive_plot <- function(data, x_data, y_data){
  data %>% 
    group_by(!!sym(x_data)) %>% 
    add_count() %>% 
    mutate(labels = ifelse(!!sym(y_data) == max(!!sym(y_data)), paste0('n = ', n), '')) %>% 
    ggplot(aes(x = !!sym(x_data),
               y = !!sym(y_data))) +
    geom_boxplot(color = "purple", 
                 width = 0.5,
                 outlier.shape = 8, 
                 outlier.size = 2) +
    
    geom_violin(color = "red", 
                fill = NA) +
    geom_jitter(width = 0.1) +
    theme_light()
}


# Create Vocabulary Difference box, point, violin plot Descriptives
vocab_diff_plt <- function(data, x_data, y_data){
  data %>% 
    descriptive_plot(., x_data, y_data) +
    geom_text(aes(label=labels, y = !!sym(y_data) + .05)) +
    ggtitle("Difference in L1 and L2 Vocabulary Size") +
    xlab("Native Language") +
    ylab("Vocabulary Difference = EN-SP")
}


# Language Dominance box, point, violin plot Descriptives
language_dominance <- function(data, x_data, y_data){
  data %>% 
    descriptive_plot(., x_data, y_data) +
    geom_text(aes(label=labels, y = !!sym(y_data) + 15)) +
    ggtitle("Language Dominance") +
    xlab("Native Language Group") +
    ylab("Basic Language Profile Dominance Score")
}


# English Vocabulary Size box, point, violin plot Descriptives
eng_lextale <- function(data, x_data, y_data){
  data %>% 
    descriptive_plot(., x_data, y_data) +
    geom_text(aes(label=labels, y = !!sym(y_data) + .05)) +
    ggtitle("English Vocabulary Size") +
    xlab("Native Language Group") +
    ylab("English Vocabulary % correct")
}


# Spanish Vocabulary Size box, point, violin plot Descriptives
esp_lextale <- function(data, x_data, y_data){
  data %>% 
    descriptive_plot(., x_data, y_data) +
    geom_text(aes(label=labels, y = !!sym(y_data) + .05)) +
    ggtitle("Spanish Vocabulary Size") +
    xlab("Native Language Group") +
    ylab("Spanish Vocabulary % correct")
}


# Izura box, point, violin plot Descriptives
izura <- function(data, x_data, y_data){
  data %>% 
    descriptive_plot(., x_data, y_data) +
    geom_text(aes(label=labels, y = !!sym(y_data) + 5)) +
    ggtitle("Spanish Vocabulary Size") +
    xlab("Native Language Group") +
    ylab("Izura Score")
}