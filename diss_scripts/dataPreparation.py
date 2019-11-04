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

def createAnalysisFiles(csvList,listName, processLists, input_Dir, output_Dir):
    import pandas as pd
    import os
    import os.path
    import pathlib

    for file in csvList:
        readDir = input_Dir + '/' + file
        df = pd.read_csv(readDir, index_col=0)
        name, ext = os.path.splitext(file)
        new_df = df.loc[:,df.columns.isin(processLists)]
        file = name + '_' + listName + '.csv'
        #newDir = Path(listName) # NOT WORKING
        #newDir.mkdir(exist_ok=True) # NOT WORKING
        #os.mkdir(listName)

        writeDir = os.path.join(output_Dir,listName)
        pathlib.Path(writeDir).mkdir(parents=True, exist_ok=True)
        #os.mkdir(writeDir)
        output_file = os.path.join(writeDir, file)
        new_df.to_csv(output_file)
    return
#new_df = df