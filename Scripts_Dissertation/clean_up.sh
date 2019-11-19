#!/bin/bash
set -e
set -x

# run this script to delete all directories, subdirectories and their contents for temporary files.

rm -r Dissertation_Experiments/segmentation/data/temp_data/
rm -r Dissertation_Experiments/segmentation/data/processed_data/part_files
# rm -r Dissertation_Experiments/segmentation/data/original_data/exp_files  #will need be added to remove later
rm -r Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data