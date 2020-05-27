import pandas as pd
processed_path = 'Dissertation_Experiments/online_lemma_segmentation/data/processed_data/'
practice = pd.read_csv('Dissertation_Experiments/online_lemma_segmentation/data/original_data/exp_files/prac_trials.csv')
experiment = pd.read_csv('Dissertation_Experiments/online_lemma_segmentation/data/original_data/exp_files/exp_trials.csv')

def block_loop(df,dir,identifier):
    #print(dir)
    blocks = df.block.unique()
    for block in blocks:
        new_df = df[df.block == block]
        path = dir + identifier + block + '.csv'
        print(path)
        new_df.to_csv(dir + identifier + block + '.csv')

block_loop(practice, processed_path + 'exp_files/','practice_')
block_loop(experiment, processed_path + 'exp_files/','experiment_')