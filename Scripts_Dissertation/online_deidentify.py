import os
import json
import pandas as pd
from Scripts_Dissertation import data_preparation

parent_dir = os.getcwd() # project working directory

# Enter list of directories to search
start_directories = [
    'Dissertation_Experiments/lemma_version/data/original_data/part_files/',
    'Dissertation_Experiments/sec_lang_lemma/data/original_data/part_files/']

# map not stored in repo to protect privacy of participants
json_path = 'Scripts_Dissertation/participant_map_online.json'

# Open json file to be used for replacements
with open(json_path, 'r') as json_file:
    replacement_map = json.load(json_file)

# Go through search directories individually
for start_dir in start_directories:
    # create list of csv files to deidentify
    csv_list = data_preparation.collect_files(parent_dir, start_dir, '*.csv')
    # remap identifying columns from dataset file by file
    for file in csv_list:
        try:
            # read the file
            df = data_preparation.read_pandas(start_dir, file, None)
            #print(df['participant'])
            # replace values in column with map
            df['participant'] = df['participant'].map(replacement_map)
            #print(df[['participant','expName']])
            # create output directory and file path changing name to participant number
            out_dir = start_dir + df.iloc[1]['participant'] + file[24:] # ProlificID is 24 char
            #print(out_dir)
            # write new csv file
            df.to_csv(out_dir)
        except pd.errors.EmptyDataError as e:
            print(f'{file} is empty...ignoring file')