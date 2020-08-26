import os
import json
import pandas as pd
from Scripts_Dissertation import data_preparation

parent_dir = os.getcwd()
start_directories = [
    'Dissertation_Experiments/lemma_version/data/original_data/part_files/',
    'Dissertation_Experiments/sec_lang_lemma/data/original_data/part_files/']
json_path = 'Scripts_Dissertation/participant_map_online.json'

with open(json_path, 'r') as json_file:
    replacement_map = json.load(json_file)

for start_dir in start_directories:
    # create list of csv files to deidentify
    csv_list = data_preparation.collect_files(parent_dir, start_dir, '*.csv')
    # remap identifying columns from dataset
    for file in csv_list:
        try:
            df = data_preparation.read_pandas(start_dir, file, None)
            print(df['participant'])
            df['participant'] = df['participant'].map(replacement_map)
            print(df[['participant','expName']])
            out_dir = start_dir + df.iloc[1]['participant'] + file[24:]
            print(out_dir)
            df.to_csv(out_dir)
        except:
            pd.errors.EmptyDataError