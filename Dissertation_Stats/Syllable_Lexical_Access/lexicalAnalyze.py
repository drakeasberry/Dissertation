# Prepare all files from experiment and for R analysis
import os
from Scripts_Dissertation import dataPreparation

# Set some directory paths needed for project
parent_dir = os.getcwd()
original_dir = 'Dissertation_Experiments/lexicalAccess/data/original_data/part_files/'
temp_dir = 'Dissertation_Experiments/lexicalAccess/data/temp_data'
processed_dir = 'Dissertation_Experiments/lexicalAccess/data/processed_data/part_files'
stats_temp_dir = 'Dissertation_Stats/Syllable_Lexical_Access/analyze_data/temp_data'
stats_out_dir = 'Dissertation_Stats/Syllable_Lexical_Access/analyze_data'
directory_list = [original_dir, temp_dir, processed_dir, stats_temp_dir, stats_out_dir]

# Create lists for separate file needed to analyze all experiments
demCols = ['partNum', 'session', 'age', 'gender', 'birthCountry', 'placeResidence', 'education', 'preferLanguage',
           'date', 'expName']
lexDuplicates = ['word', 'translation']
lexEsp = ['corrAnsEspV', 'lexRespEsp', 'lexRespEspCorr', 'lexRespEspRT']
lexEng = ['corrAnsEngV', 'lexRespEng', 'lexRespEngCorr', 'lexRespEngRT']
syl = ['syllabification', 'corrSyl', 'corrAns', 'leftKey', 'rightKey', 'condition', 'sylResp', 'sylRespCorr',
       'sylRespRT', ]
blp = ['questionNum', 'color', 'sectionEng', 'questionTextEng', 'languageEng', 'langHistResp1', 'langHistRT1',
       'langHistResp2', 'langHistRT2', 'langHistResp3', 'langHistRT3', 'langUseResp', 'langUseRT', 'langProfResp',
       'langProfRT', 'langAttResp', 'langAttRT']
lexical = ['Word', 'corrAns', 'initialSylStress', 'sylStruc', 'wordStatus', 'freq_WPM', 'numRevealed', 'Prime', 'matching', 'lex_key_resp.keys', 'lex_key_resp.corr', 'lex_key_resp.rt',]
lexEspCols = [*lexDuplicates, *lexEsp, *demCols]
lexEngCols = [*lexDuplicates, *lexEng, *demCols]
sylCols = [*syl, *demCols]
blpCols = [*blp, *demCols]
lexCols = [*lexical, *demCols]
lexicalKeepCols = [*lexDuplicates, *lexEsp, *lexEng, *sylCols, *lexCols, *blpCols, *demCols]
listOfLists = {'lexEngCols':lexEngCols, 'lexEspCols':lexEspCols, 'sylCols':sylCols, 'blpCols':blpCols, 'lexCols':lexCols}

# create directory structure for project
for directory in directory_list:
    dataPreparation.createDirectory(directory)

# create list of csv files to modify and rename headers
csvList = dataPreparation.collectFiles(parent_dir, original_dir)
print(csvList)
# change the headers of csv files
dataPreparation.reMapPandasHeaders('Scripts_Dissertation/replacement_map.json', csvList, original_dir, temp_dir)

# get list of csv files to modify and select desired columns
csvList_new_headers = dataPreparation.collectFiles(parent_dir, temp_dir)

# Eliminates all unnecessary columns written by PsychoPy
dataPreparation.delPsyPyCols(csvList_new_headers, lexicalKeepCols, temp_dir, processed_dir)

# get list of csv files to modify, splits files and moves to stats temporary directory
csvList_to_split = dataPreparation.collectFiles(parent_dir, processed_dir)

# Splits file into subsets for analysis and pastes them into temporary directory of stats
for curList in listOfLists:
    listName = listOfLists.get(curList)
    #print(csvList_to_split) # prints out list of filenames associated with query
    #print(curList) # prints list name
    #print(listName) # prints out column names to keep
    #print(processed_dir) # prints directory path that data is pulled from
    #print(stats_temp_dir) # prints directory path that data is written to
    dataPreparation.createAnalysisDirectories(csvList_to_split, curList, listName, processed_dir, stats_temp_dir)

# creates subdirectories in rFiles directory for each experiment with subset files ready for rStudio import
for curList in listOfLists:
    listName = listOfLists.get(curList)
    list_dir = stats_temp_dir + '/' + curList
    #print('parent directory: ', parent_dir)
    #print('list directory: ', list_dir)
    csvList_to_subset = dataPreparation.collectFiles(parent_dir, list_dir)
    #print(csvList_to_split)
    dataPreparation.createAnalysisFiles2(csvList_to_subset, curList, list_dir, parent_dir)


