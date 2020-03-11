#!/bin/bash
#!/usr/bin/Rscript

# Load Libraries
library(plyr)
library(readr)
library(tidyverse)

# LexTALE-English Data Directory
engDir = 'analyze_data/lexEngCols' #set path to directory
engFiles = list.files(path=engDir, pattern = '*.csv', full.names = TRUE) #list all the files with path
#print(engFiles)
# read in all the files into one data frame
engData = ldply(engFiles, read_csv)

# LexTALE-Spanish Data Directory
espDir = 'analyze_data/lexEspCols' #set path to directory
espFiles = list.files(path=espDir, pattern = '*.csv', full.names = TRUE) #list all the files with path

# read in all the files into one data frame
espData = ldply(espFiles, read_csv)

# Basic Langauge Profile Data Directory
blpDir = 'analyze_data/blpCols' #set path to directory
blpFiles = list.files(path=blpDir, pattern = '*.csv', full.names = TRUE) #list all the files with path

# read in all the files into one data frame
blpData = ldply(blpFiles, read_csv)

# create one column for History responses
blpData$langHistResp3[1:2] <- blpData$langHistResp1[1:2]
blpData$langHistResp3[3:4] <- blpData$langHistResp2[3:4]