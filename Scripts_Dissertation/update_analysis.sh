#!/bin/bash
set -e
set -x

# Run this file when new data is collected. It reruns all data transformations and analysis

# Ensure are (sub)directories are in place
sh Scripts_Dissertation/build_directory.sh

# Run segmentation analysis
export PYTHONPATH=.
pipenv run python Dissertation_Stats/Syllable_Segmentation/segAnalyze.py

# Run R analysis
# Rscript Scripts_Dissertation/Rmd_to_Rscript.r # convert R markdown to R script
Rscript Dissertation_Stats/Syllable_Segmentation/Syllable_Segmentation.r

# Run clean up to remove unecessary files
sh Scripts_Dissertation/clean_up.sh # comment this line out if you would like to view all intermediate temporary files

# Let the user know the operation is complete
echo 'Analysis updated'