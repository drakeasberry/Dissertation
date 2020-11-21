#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(readr)
library(tidyverse)
library(ggpubr)
library(afex)
library(ggplot2)

# Create Vocabulary Difference box, point, violin plot Descriptives
vocab_diff_plt <- function(data){
  data %>% 
    group_by(group) %>% 
    add_count() %>% 
    mutate(labels = ifelse(diff == max(diff), paste0('n = ', n), '')) %>%
    ggplot(aes(x = group,
               y = diff)) +
    geom_boxplot(color = "purple", width = 0.5,
                 outlier.shape = 8, outlier.size = 2) +
    geom_text(aes(label=labels, y = diff + .05)) +
    geom_violin(color = "red", fill = NA) +
    geom_jitter(width = 0.1) +
    ggtitle("Difference in L1 and L2 Vocabulary Size") +
    xlab("Native Language") +
    ylab("Vocabulary Difference = EN-SP") +
    theme_light()
  }