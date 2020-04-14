# Functions used to modify experiment files for data analysis in R
import pandas as pd
import json
import os
import glob
import pathlib


# checks to see if directory exists and creates new directories when not found
def create_directory(path):
    pathlib.Path(path).mkdir(parents=True, exist_ok=True)
    return


# read in csv files as pandas dataframe
def read_pandas(path, file):
    read_dir = path + '/' + file
    df = pd.read_csv(read_dir, index_col=0)
    return df


# Remove identifying data from files
def de_indentify(csv_files, drop_columns, input_dir, output_dir):
    for file in csv_files:
        df = read_pandas(input_dir, file)
        try:
            new_df = df.drop(columns=drop_columns)
            write_dir = output_dir + '/' + file
            new_df.to_csv(write_dir)
        except:
            KeyError
    return


# replaces header names in csv files and creates a copy in a temporary directory
def remap_pandas_headers(json_path, csv_files, input_dir, output_dir):
    with open(json_path, 'r') as json_file:
        replacement_map = json.load(json_file)

    for file in csv_files:
        df = read_pandas(input_dir, file)
        original_header = list(df)
        new_header = [replacement_map.get(originalName) or originalName for originalName in original_header]
        write_dir = output_dir + '/' + file
        df.to_csv(write_dir, header=new_header)
    return


# creates a list of all csv files in specified directory
def collect_files(parent_dir, search_dir):
    os.chdir(search_dir)  # I had to add this in to avoid the housing directory from being part of file name
    csv_list = glob.glob('*.csv')
    os.chdir(parent_dir)  # resets it back to where it needed to go. Is there an easier way to do this?
    return csv_list


# Eliminates all unnecessary columns written by PsychoPy
def del_psycopy_cols(csv_files, keep_columns, input_dir, output_dir):
    for file in csv_files:
        df = read_pandas(input_dir, file)
        new_df = df.loc[:, df.columns.isin(keep_columns)]
        write_dir = output_dir + '/' + file
        new_df.to_csv(write_dir)
    return


# prepares pandas dataframes to be moved to appropriate analysis directories
def anaylsis_directory_moves(file, list_name, process_lists, input_dir, output_dir):
    # print('process list inside function: ',process_lists)
    # print('input directory inside function: ',input_dir)
    df = read_pandas(input_dir, file)
    name, ext = os.path.splitext(file)
    # print('filename inside function: ',name)
    new_df = df.loc[:, df.columns.isin(process_lists)]
    file = name + '_' + list_name + '.csv'
    write_dir = os.path.join(output_dir, list_name)
    # print('write directory inside function: ',write_dir)
    pathlib.Path(write_dir).mkdir(parents=True, exist_ok=True)
    output_file = os.path.join(write_dir, file)
    # print('out file inside function: ',output_file)
    new_df.to_csv(output_file)
    return


# Creates new directories and places new csv analysis files in appropriate subdirectories
def create_analysis_directories(skip_files, csv_files, list_name, process_lists, input_dir, output_dir):
    for file in csv_files:
        # print(file)
        if file in skip_files:  # this not matching expression
            if list_name == 'lexical_cols':
                anaylsis_directory_moves(file, list_name, process_lists, input_dir, output_dir)
            else:
                pass
                #print(file, 'has been skipped for returning participant.')
        else:
            anaylsis_directory_moves(file, list_name, process_lists, input_dir, output_dir)
    return


# Creates new directories and places new csv analysis files in appropriate subdirectories
def create_analysis_files(csv_files, list_name, input_dir, output_dir):
    subset_key_list = ['lextaleRespEngCorr', 'lextaleRespEspCorr', 'sylRespCorr', 'questionNum', 'fillerCarrier',
                       'lexicalRespCorr']
    demo_dir = 'Statistics/Demographics/analyze_data'
    syllable_dir = 'Statistics/Intuition/analyze_data'
    lexical_dir = 'Statistics/Lexical_Access/analyze_data'
    segmentation_dir = 'Statistics/Segmentation/analyze_data'
    file_locations = ['Statistics/Segmentation/analyze_data/temp_data/lextale_eng_cols',
                      'Statistics/Lexical_Access/analyze_data/temp_data/lextale_eng_cols',
                      'Statistics/Segmentation/analyze_data/temp_data/lextale_esp_cols',
                      'Statistics/Lexical_Access/analyze_data/temp_data/lextale_esp_cols',
                      'Statistics/Segmentation/analyze_data/temp_data/syl_cols',
                      'Statistics/Lexical_Access/analyze_data/temp_data/syl_cols',
                      'Statistics/Segmentation/analyze_data/temp_data/blp_cols',
                      'Statistics/Lexical_Access/analyze_data/temp_data/blp_cols',
                      'Statistics/Segmentation/analyze_data/temp_data/seg_cols',
                      'Statistics/Lexical_Access/analyze_data/temp_data/lexical_cols']

    for file in csv_files:
        df = read_pandas(input_dir, file)
        name, ext = os.path.splitext(file)

        if input_dir in file_locations[0:2]:
            key = subset_key_list[0]
            write_dir = os.path.join(output_dir, demo_dir, list_name)
        elif input_dir in file_locations[2:4]:
            key = subset_key_list[1]
            write_dir = os.path.join(output_dir, demo_dir, list_name)
        elif input_dir in file_locations[4:6]:
            key = subset_key_list[2]
            write_dir = os.path.join(output_dir, syllable_dir, 'raw')
        elif input_dir in file_locations[6:8]:
            key = subset_key_list[3]
            write_dir = os.path.join(output_dir, demo_dir, list_name)
        elif input_dir in file_locations[8]:
            key = subset_key_list[4]
            write_dir = os.path.join(output_dir, segmentation_dir, 'raw')
        elif input_dir in file_locations[9]:
            key = subset_key_list[5]
            write_dir = os.path.join(output_dir, lexical_dir, 'raw')
        else:
            print('something went wrong')

        new_df = df.dropna(subset=[key])

        pathlib.Path(write_dir).mkdir(parents=True, exist_ok=True)
        #print('write directory inside function: ', write_dir)  # prints write directory
        output_file = os.path.join(write_dir, file)
        #print('out file inside function: ', output_file)  # prints filename going to write directory
        new_df.to_csv(output_file)
    return