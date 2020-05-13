import pandas as pd
import os
from Scripts_Dissertation import segFunctions, data_preparation

#exp_dir = 'Dissertation_Experiments/online_segmentation'
#starting_workbook = exp_dir + '/Segmentation_Experimental_Item_Setup.xlsx'
#
## runs the csv_from_excel function:
## creates csv for segmentation experiment lists
#segFunctions.csv_from_excel(starting_workbook,'All_SegExperiment_Lists','Dissertation_Experiments/online_segmentation/data/original_data/exp_files/expLists_all.csv')
#
## creates csv for segmentation practice lists
#segFunctions.csv_from_excel(starting_workbook,'All_SegPractice_Lists', exp_dir + '/data/original_data/exp_files/pracLists_all.csv')
#
## creates csv for syllabification experiment lists
#segFunctions.csv_from_excel(starting_workbook,'Syllabification_Lists', exp_dir + '/data/original_data/exp_files/sylexpLists_all.csv')
#
## creates csv for syllabification practice lists
#segFunctions.csv_from_excel(starting_workbook,'Syllabification_Practice', exp_dir + '/data/original_data/exp_files/sylpracLists_all.csv')
#
## creates csv for LexTALE Spanish lists
#segFunctions.csv_from_excel(starting_workbook,'LexTaleEsp', exp_dir + '/data/processed_data/exp_files/lexTaleListEng.csv')
#
## creates csv for LexTALE English lists
#segFunctions.csv_from_excel(starting_workbook,'LexTaleEng', exp_dir + '/data/processed_data/exp_files/lexTaleListEsp.csv')
#
## creates csv for Basic Language Profile Survey lists
#segFunctions.csv_from_excel(starting_workbook,'BasicLangProfile', exp_dir + '/data/processed_data/exp_files/sp_en_blp_trials.csv')


exp_dir = 'Dissertation_Experiments/online_segmentation'
starting_workbook = exp_dir + '/Segmentation_Experimental_Item_Setup.xlsx'
sheetNameList = ['All_SegExperiment_Lists','All_SegPractice_Lists','Syllabification_Lists',
                 'Syllabification_Practice','LexTaleEsp','LexTaleEng','BasicLangProfile']
outFileList = ['expLists_all.csv','pracLists_all.csv','sylexpLists_all.csv',
               'sylpracLists_all.csv','lexTaleListEsp.csv','lexTaleListEng.csv',
               'sp_en_blp_trials.csv']
savePath = exp_dir + '/data/temp_data/'
tempPath = exp_dir + '/data/original_data/exp_files/'

i = 0
for sheet in sheetNameList:
    saveFile = savePath + outFileList[i]
    tempDestination =  tempPath + outFileList[i]
    # runs the csv_from_excel function:
    # creates csv for segmentation experiment lists
    segFunctions.csv_from_excel(starting_workbook,sheetNameList[i],tempDestination)
    i += 1

assert i == len(sheetNameList)

#remove sheets that are not necessary
outFileList.remove('expLists_all.csv')
outFileList.remove('pracLists_all.csv')
outFileList.remove('sp_en_blp_trials.csv')
print(outFileList)

fix_columns = ['corrAns', 'corrAns', 'corrAnsEspV', 'corrAnsEngV']
i = 0
for file in outFileList:
    fix_col = fix_columns[i]
    file_path = tempPath + file
    save_loc = savePath + file
    #print(fix_col)
    segFunctions.fix_csv(file_path, save_loc, {fix_col: lambda x: int(float(x))})
    i += 1

# move fixed csv files back to original data folder
temp_file_list = data_preparation.collect_files(os.getcwd(), savePath, '*.csv')
data_preparation.copy_files(temp_file_list, savePath, tempPath)
data_preparation.clear_old_files(savePath,'.csv')



# creates list for all trial types
trialType = ['exp','prac','sylexp','sylprac'] # list for trial type and naming
condName = ['A','B','C','D'] # list for condition labels
expsylRange = [0,47,0,47,48,96,48,96] # list for slicing syllable ranges
expsegRange = [0,12,15,27,30,42,45,57] # list for slicing segmentation ranges
pracsylRange = [0,9,0,9,10,19,10,19] # list for slicing syllable practice ranges

# runs through each condition for practice and experimental list conditions
for trial in trialType:
    i = 0 # set counter for start syl and seg ranges
    j = 1 # set counter for end syl and seg ranges
    # Reads in the newly created csv files
    df = pd.read_csv(exp_dir + '/data/original_data/exp_files/' + trial + 'Lists_all.csv')

    for cond in condName: # sets up loop to run through 4 conditions (ABCD)
        if trial == 'sylprac': # Tests for sylprac lists
            condition = df.loc[pracsylRange[i]:pracsylRange[j],:] # selects all rows for list
            condition.to_csv(exp_dir + '/data/temp_data/' + trial + 'Cond' + cond + '.csv') # saves temp file for further work
            i += 2 # adds two to value to change range
            j += 2 # adds two to value to change range
        elif trial == 'sylexp': # test for syllable lists
            condition = df.loc[expsylRange[i]:expsylRange[j],:] # selects all rows for list
            condition.to_csv(exp_dir + '/data/temp_data/' + trial + 'Cond' + cond + '.csv') # saves temp file for further work
            i += 2 # adds two to value to change range
            j += 2 # adds two to value to change range
        else: # captures both practice and real segmentation experiment lists
            condition = df.loc[expsegRange[i]:expsegRange[j],:] # selects all rows for list
            condition.to_csv(exp_dir + '/data/temp_data/' + trial + 'Cond' + cond + '.csv') # saves temp file for further work
            i += 2 # adds two to value to change range
            j += 2 # adds two to value to change range

# Reads in new csv files from temp folder and makes final changes for PyschoPy

# sets list letters for the four condition file names (used in practice and experiments)
indexName = ['labels','labels','syllabification','syllabification'] # lists for dataframe indexing
blockName = ['block01','block08','block48'] # lists for slice ranges
k = 0 # sets counter for indexing list
b = 2 # sets counter for slicing range list

# runs through each of the 4 condition files
for trial in trialType:
    # captures all files types with 4 conditions
    for cond in condName: # runs through all 4 conditions
        df_cond = pd.read_csv(exp_dir + '/data/temp_data/' + trial + 'Cond' + cond + '.csv',index_col=indexName[k]) # read csv
        # test to see whether header must be omitted
        if trial == 'sylprac': # test for syl practice because filename is odd since only one condition exists
            # deletes the unnamed column populated from Excel Row ranges
            df_cond.drop('Unnamed: 0', axis = 1, inplace = True)
            df_cond.to_csv(exp_dir + '/data/processed_data/exp_files/' + trial + 'Cond' + cond + '.csv') # writes csv file to processed folder
        elif trial == 'sylexp': # tests for syl practice because header must be retained
            df_cond.to_csv(exp_dir + '/data/processed_data/exp_files/' + trial + 'Cond'+ cond + '.csv') # writes csv
        else: # captures both segmenation tasks with 4 conditions
            # sorts the columns in dataframe alphabetically
            df_cond = df_cond.reindex(sorted(df_cond.columns), axis=1)
            clist_cond = df_cond.loc[:,blockName[0]:blockName[b]] #stores variable with subset data
            # writes out the new csv to processed_data folder which is ready for PyschoPy
            clist_cond.to_csv(exp_dir + '/data/processed_data/exp_files/' + trial + 'Cond' + cond + '.csv',header=False)
    b = b-1 # lowers the blockName range counter to change for practice trials
    k += 1 # increases indexing number to iterate to indexName list

# Delete temprorary files created by script
temp_file_list = data_preparation.collect_files(os.getcwd(), savePath, '*.csv')
data_preparation.copy_files(temp_file_list, savePath, tempPath)
data_preparation.clear_old_files(savePath,'.csv')

# Move lexTale and BLP files to processed for pyschopy access
demo_file_list = ['lexTaleListEsp.csv', 'lexTaleListEng.csv', 'sp_en_blp_trials.csv']
#for file in demo_file_list:
#    file_path = tempPath + file
data_preparation.copy_files(demo_file_list, tempPath, exp_dir + '/data/processed_data/exp_files/')