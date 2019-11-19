#!/bin/bash
set -e
set -x

# run this script to create all directories and subdirectories for dissertation data.

# Experiment Directory
mkdir -p Dissertation_Experiments/segmentation/data/temp_data
mkdir -p Dissertation_Experiments/segmentation/data/original_data/exp_files
mkdir -p Dissertation_Experiments/segmentation/data/original_data/part_files
mkdir -p Dissertation_Experiments/segmentation/data/processed_data/exp_files
mkdir -p Dissertation_Experiments/segmentation/data/processed_data/part_files
mkdir -p Dissertation_Experiments/lexicalAccess/data/temp_data
mkdir -p Dissertation_Experiments/lexicalAccess/data/original_data/exp_files
mkdir -p Dissertation_Experiments/lexicalAccess/data/original_data/part_files
mkdir -p Dissertation_Experiments/lexicalAccess/data/processed_data/exp_files
mkdir -p Dissertation_Experiments/lexicalAccess/data/processed_data/part_files

# Statistics Directory
mkdir -p Dissertation_Stats/Demographics/analyze_data/blpCols
mkdir -p Dissertation_Stats/Demographics/analyze_data/lexEngCols
mkdir -p Dissertation_Stats/Demographics/analyze_data/lexEspCols
mkdir -p Dissertation_Stats/Syllable_Intuition/analyze_data
mkdir -p Dissertation_Stats/Syllable_Lexical_Access/analyze_data
mkdir -p Dissertation_Stats/Syllable_Segmentation/analyze_data

# Manuscript Directory
mkdir -p Asberry_Dissertation

