#!/bin/bash
set -e
set -x

# Run this file when new data is collected. It reruns all data transformations and analysis

# Ensure are (sub)directories are in place
sh Scripts_Dissertation/build_directory.sh

# Get rid of special characters in file names here

# Run segmentation analysis
export PYTHONPATH=.
pipenv run python Statistics/Segmentation/seg_analyze.py

# Run lexical access analysis
pipenv run python Statistics/Lexical_Access/lexical_analyze.py

# Run online study learners analysis
pipenv run python Statistics/L2_lemma/sec_lang_lemma_anaylze.py

# Run online study natives analysis
pipenv run python Statistics/Monolingual_lemma/lemma_anaylze.py

# Run R analysis
#cd Statistics/Segmentation/
#Rscript segmentation_stats.r
#cd ../Lexical_Access/
#Rscript lexical_access_stats.r
#cd ../Intuition/
#Rscript intuition_stats.r
#cd ../Demographics/
#Rscript demographic_stats.r

# Run clean up to remove unnecessary files
#cd ../..
#sh Scripts_Dissertation/clean_up.sh # comment this line out if you would like to view all intermediate temporary files

# Let the user know the operation is complete
echo 'Analysis updated'