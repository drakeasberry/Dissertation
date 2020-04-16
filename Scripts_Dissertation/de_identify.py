import data_preparation
import os

parent_dir = os.getcwd()
start_directories = [
    'Dissertation_Experiments/segmentation/data/original_data/part_files/',
    'Dissertation_Experiments/lexicalAccess/data/original_data/part_files/']
drop_list = ["03_Nombre (First name):", "04_Apellido (Last name):"]

for start_dir in start_directories:
    # create list of csv files to deidentify
    csv_list = data_preparation.collect_files(parent_dir, start_dir)
    # drop identifying columns from dataset
    data_preparation.de_indentify(csv_list, drop_list, start_dir, start_dir)
