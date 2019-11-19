# Functions used to modify experiment files for data analysis in R
import pandas as pd
import json
import os
import glob
import pathlib

# checks to see if directory exists and creates new directories when not found
def createDirectory(path):
    pathlib.Path(path).mkdir(parents=True, exist_ok=True)
    return

# read in csv files as pandas dataframe
def readPandas(path,file):
    readDir = path + '/' + file
    df = pd.read_csv(readDir, index_col=0)
    return df

# Remove identifying data from files
def deIndentify(csv_files, drop_columns, input_dir, output_dir):
    for file in csv_files:
        df = readPandas(input_dir, file)
        try:
            new_df = df.drop(columns=drop_columns)
            writeDir = output_dir + '/' + file
            new_df.to_csv(writeDir)
        except: KeyError
    return

# replaces header names in csv files and creates a copy in a temporary directory
def reMapPandasHeaders(json_path, csv_files, input_dir, output_dir):
    with open(json_path, 'r') as json_file:
        replacement_map = json.load(json_file)

    for file in csv_files:
        df = readPandas(input_dir, file)
        originalHeader = list(df)
        newHeader = [replacement_map.get(originalName) or originalName for originalName in originalHeader]
        writeDir = output_dir + '/' + file
        df.to_csv(writeDir, header=newHeader)
    return

# creates a list of all csv files in specified directory
def collectFiles(parent_dir, search_dir):
    os.chdir(search_dir) # I had to add this in to avoid the housing directory from being part of file name
    csvList = glob.glob('*.csv')
    os.chdir(parent_dir) # resets it back to where it needed to go. Is there an easier way to do this?
    return csvList

# Eliminates all unnecessary columns written by PsychoPy
def delPsyPyCols(csv_files, keep_columns, input_dir, output_dir):
    for file in csv_files:
        df = readPandas(input_dir, file)
        new_df = df.loc[:, df.columns.isin(keep_columns)]
        writeDir = output_dir + '/' + file
        new_df.to_csv(writeDir)
    return

# Creates new directories and places new csv anlysis files in appropriate subdirectories
def createAnalysisDirectories(csv_files, list_name, process_lists, input_dir, output_dir):
    for file in csv_files:
        df = readPandas(input_dir, file)
        name, ext = os.path.splitext(file)
        new_df = df.loc[:,df.columns.isin(process_lists)]
        file = name + '_' + list_name + '.csv'
        writeDir = os.path.join(output_dir, list_name)
        pathlib.Path(writeDir).mkdir(parents=True, exist_ok=True)
        output_file = os.path.join(writeDir, file)
        new_df.to_csv(output_file)
    return

# Creates new directories and places new csv anlysis files in appropriate subdirectories
def createAnalysisFiles(csv_files, list_name, input_dir, output_dir):
    subset_key_list = ['corrAnsEngV', 'corrAnsEspV', 'sylRespCorr', 'questionNum', 'fillerCarrier']

    for file in csv_files:
        df = readPandas(input_dir, file)
        name, ext = os.path.splitext(file)

        if input_dir == 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data/lexEngCols':
            key = subset_key_list[0]
        elif input_dir == 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data/lexEspCols':
            key = subset_key_list[1]
        elif input_dir == 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data/sylCols':
            key = subset_key_list[2]
        elif input_dir == 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data/blpCols':
            key = subset_key_list[3]
        elif input_dir == 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data/segCols':
            key = subset_key_list[4]
        else: print('something went wrong')

        new_df=df.dropna(subset=[key])

        writeDir = os.path.join(output_dir, list_name)
        pathlib.Path(writeDir).mkdir(parents=True, exist_ok=True)
        output_file = os.path.join(writeDir, file)
        new_df.to_csv(output_file)
    return
