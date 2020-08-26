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
mkdir -p Statistics/Demographics/analyze_data/blp_cols
mkdir -p Statistics/Demographics/analyze_data/lextale_eng_cols
mkdir -p Statistics/Demographics/analyze_data/lextale_esp_cols
mkdir -p Statistics/Intuition/analyze_data
mkdir -p Statistics/Intuition/analyze_data/raw
mkdir -p Statistics/Intuition/analyze_data/transformed
mkdir -p Statistics/Lexical_Access/analyze_data
mkdir -p Statistics/Lexical_Access/analyze_data/raw
mkdir -p Statistics/Lexical_Access/analyze_data/transformed
mkdir -p Statistics/Segmentation/analyze_data
mkdir -p Statistics/Segmentation/analyze_data/raw
mkdir -p Statistics/Segmentation/analyze_data/transformed
mkdir -p Statistics/Monolingual_lemma/analyze_data/temp_data/lextale_esp_cols
mkdir -p Statistics/Monolingual_lemma/analyze_data/temp_data/seg_cols
mkdir -p Statistics/L2_lemma/analyze_data/temp_data/lextale_esp_cols
mkdir -p Statistics/L2_lemma/analyze_data/temp_data/seg_cols

# Manuscript Directory
mkdir -p Asberry_Dissertation