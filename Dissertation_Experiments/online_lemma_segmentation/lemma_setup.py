import pandas as pd
from Scripts_Dissertation import data_preparation

# set project paths
project_parent = 'Dissertation_Experiments/online_lemma_segmentation/'
original_path = 'Dissertation_Experiments/online_lemma_segmentation/data/original_data/'
processed_path = 'Dissertation_Experiments/online_lemma_segmentation/data/processed_data/'
experiment_file = 'exp_files/'
participant_file = 'part_files/'

# Create csv files for experiment
# Enter filenames without extensions
trial_list = ['16_prac_trials', '64_exp_trials']
sheet_names = ['Sheet1']

# Loop through all files to create csv outputs
for trial in trial_list:
    data_preparation.csv_from_excel(project_parent + trial + '.xlsx',
                                    sheet_names[0],
                                    original_path + experiment_file + trial + '.csv')

# Read csv data files containing experimental items
practice = pd.read_csv(original_path + experiment_file + '16_prac_trials.csv', encoding='utf8', index_col=False)
experiment = pd.read_csv(original_path + experiment_file + '64_exp_trials.csv', encoding='utf8', index_col=False)

def block_loop(df,dir,identifier):
    #print(dir)
    blocks = df.block.unique()
    for block in blocks:
        new_df = df[df.block == block]
        path = dir + identifier + block + '.csv'
        print(path)
        new_df.to_csv(dir + identifier + block + '.csv', encoding='utf-8-sig', index=False)

block_loop(practice, processed_path + experiment_file,'practice_')
block_loop(experiment, processed_path + experiment_file,'experiment_')