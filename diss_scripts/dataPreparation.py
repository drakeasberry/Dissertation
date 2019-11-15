# Prepares output csv experiment files for data analysis

# replaces header names in csv files and creates a copy in a temporary directory
def reMapPandasHeaders(jsonPath, csvList, input_Dir, output_Dir):
    import pandas as pd
    import json

    with open(jsonPath, 'r') as json_file:
        replacement_map = json.load(json_file)

    for file in csvList:
        readDir = input_Dir + '/' + file
        df = pd.read_csv(readDir)
        originalHeader = list(df)
        newHeader = [replacement_map.get(originalName) or originalName for originalName in originalHeader]
        writeDir = output_Dir + '/' + file
        df.to_csv(writeDir, header=newHeader)
    return

# creates a list of all csv files in specified directory
def collectFiles(parentDir, startDir):
    import os
    import glob

    os.chdir(startDir) # I had to add this in to avoid the housing directory from being part of file name
    csvList = glob.glob('*.csv')
    os.chdir(parentDir) # resets it back to where it needed to go. Is there an easier way to do this

    return csvList

# Eliminates all unnecessary columns written by PsychoPy
def delPsyPyCols(csvList, keepColumns, input_Dir, output_Dir):
    import pandas as pd

    for file in csvList:
        readDir = input_Dir + '/' + file
        df = pd.read_csv(readDir, index_col=0)
        new_df = df.loc[:, df.columns.isin(keepColumns)]
        writeDir = output_Dir + '/' + file
        new_df.to_csv(writeDir)

    return

# Creates new directories and places new csv anlysis files in appropriate subdirectories
def createAnalysisFiles(csvList,listName, processLists, input_Dir, output_Dir):
    import pandas as pd
    import os.path
    import pathlib

    key_list = ['corrAnsEngV', 'corrAnsEspV', 'sylRespCorr', 'questionNum', 'fillerCarrier']

    for file in csvList:
        readDir = input_Dir + '/' + file
        df = pd.read_csv(readDir, index_col=0)
        name, ext = os.path.splitext(file)
        if input_Dir == 'Dissertation_Experiments/segmentation/data/processed_data/part_files':
            new_df = df.loc[:,df.columns.isin(processLists)]
            file = name + '_' + listName + '.csv'
        else:
            if input_Dir == 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data/lexEngCols':
                key = key_list[0]
            elif input_Dir == 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data/lexEspCols':
                key = key_list[1]
            elif input_Dir == 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data/sylCols':
                key = key_list[2]
            elif input_Dir == 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data/blpCols':
                key = key_list[3]
            elif input_Dir == 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data/segCols':
                key = key_list[4]
            else: print('something went wrong')

            new_df=df.dropna(subset=[key])  # working but need variable to iterate 5 tests

        writeDir = os.path.join(output_Dir,listName)
        pathlib.Path(writeDir).mkdir(parents=True, exist_ok=True)
        output_file = os.path.join(writeDir, file)
        new_df.to_csv(output_file)
    return
