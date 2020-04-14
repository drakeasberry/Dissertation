#!/bin/bash
set -e
set -x

# run this script to delete all directories, subdirectories and their contents for temporary files.

# Removes temporary files related to segmentation experiment
rm -r Dissertation_Experiments/segmentation/data/temp_data/
rm -r Dissertation_Experiments/segmentation/data/processed_data/part_files
# rm -r Dissertation_Experiments/segmentation/data/original_data/exp_files  #will need be added to remove later
rm -r Statistics/Segmentation/analyze_data/temp_data

# Removes temporary files related to lexical access experiment
rm -r Dissertation_Experiments/lexicalAccess/data/temp_data/
rm -r Dissertation_Experiments/lexicalAccess/data/processed_data/part_files
# rm -r Dissertation_Experiments/lexicalAccess/data/original_data/exp_files  #will need be added to remove later
rm -r Statistics/Lexical_Access/analyze_data/temp_data