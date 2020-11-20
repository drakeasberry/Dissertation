#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(plyr)
library(readr)
library(tidyverse)
library(psych)
library(lattice)
library(tidyr)

# Create 'not in' function
'%ni%' <- Negate('%in%')

# Soruce Scripts containing functions
source("../../Scripts_Dissertation/segmentation_dataviz_script.R")