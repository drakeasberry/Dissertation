# Prepare all files from experiment and for R analysis
import os
from Scripts_Dissertation import dataPreparation

# Set some directory paths needed for project
parent_dir = os.getcwd()
original_dir = 'Dissertation_Experiments/segmentation/data/original_data/part_files/'
temp_dir = 'Dissertation_Experiments/segmentation/data/temp_data'
processed_dir = 'Dissertation_Experiments/segmentation/data/processed_data/part_files'
stats_temp_dir = 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data'
stats_out_dir = 'Dissertation_Stats/Syllable_Segmentation/analyze_data'
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
seg = ['fillerCarrier', 'block01', 'block02', 'block03', 'block04', 'block05', 'block06', 'block07', 'block08',
       'block09', 'block10', 'block11', 'block12', 'block13', 'block14', 'block15', 'block16', 'block17', 'block18',
       'block19', 'block20', 'block21', 'block22', 'block23', 'block24', 'block25', 'block26', 'block27', 'block28',
       'block29', 'block30', 'block31', 'block32', 'block33', 'block34', 'block35', 'block36', 'block37', 'block38',
       'block39', 'block40', 'block41', 'block42', 'block43', 'block44', 'block45', 'block46', 'block47', 'block48',
       'segResp', 'segRespRT']
lexEspCols = [*lexDuplicates, *lexEsp, *demCols]
lexEngCols = [*lexDuplicates, *lexEng, *demCols]
sylCols = [*syl, *demCols]
blpCols = [*blp, *demCols]
segCols = [*seg, *demCols]
segKeepCols = [*lexDuplicates, *lexEsp, *lexEng, *sylCols, *segCols, *blpCols, *demCols]
listOfLists = {'lexEngCols':lexEngCols, 'lexEspCols':lexEspCols, 'sylCols':sylCols, 'blpCols':blpCols, 'segCols':segCols}

# create directory structure for project
for directory in directory_list:
    dataPreparation.createDirectory(directory)

# create list of csv files to modify and rename headers
csvList = dataPreparation.collectFiles(parent_dir, original_dir)
# change the headers of csv files
dataPreparation.reMapPandasHeaders('Scripts_Dissertation/replacement_map.json', csvList, original_dir, temp_dir)

# get list of csv files to modify and select desired columns
csvList_new_headers = dataPreparation.collectFiles(parent_dir, temp_dir)
# Eliminates all unnecessary columns written by PsychoPy
dataPreparation.delPsyPyCols(csvList_new_headers, segKeepCols, temp_dir, processed_dir)

# get list of csv files to modify, splits files and moves to stats temporary directory
csvList_to_split = dataPreparation.collectFiles(parent_dir, processed_dir)
# Splits file into subsets for analysis and pastes them into temporary directory of stats
for curList in listOfLists:
    listName = listOfLists.get(curList)
    #print(csvList_to_split)
    #print(curList)
    #print(listName)
    #print(processed_dir)
    #print(stats_temp_dir)
    dataPreparation.createAnalysisDirectories(csvList_to_split, curList, listName, processed_dir, stats_temp_dir)

# creates subdirectories in rFiles directory for each experiment with subset files ready for rStudio import
for curList in listOfLists:
    listName = listOfLists.get(curList)
    list_dir = stats_temp_dir + '/' + curList
    csvList_to_subset = dataPreparation.collectFiles(parent_dir, list_dir)
    dataPreparation.createAnalysisFiles(csvList_to_subset, curList, list_dir, parent_dir)


