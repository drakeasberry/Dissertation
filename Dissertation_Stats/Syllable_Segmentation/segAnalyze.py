# Prepare all files from experiment and run R analysis
import os
#import sys
#sys.path.append('../../scripts/') # commented out after Julian suggestion
from scripts import dataPreparation
import requests

#pandas settings
#pd.set_option('display.max_rows', 500)
#pd.set_option('display.max_columns',200)

# Set some global variables
parentDir = os.getcwd()
print(parentDir)
startDir = 'Dissertation_Experiments/segmentation/data/original_data/part_files/'
tempDir = 'Dissertation_Experiments/segmentation/data/temp_data'
outDir = 'Dissertation_Experiments/segmentation/data/processed_data/part_files'
statsSegDir = 'Dissertation_Stats/Syllable_Segmentation/analyze_data/temp_data'
statsOutDir = 'Dissertation_Stats/Syllable_Segmentation/analyze_data/rFiles'

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
listOfLists = [lexEngCols, lexEspCols, sylCols, blpCols, segCols]
strListOfLists = ['lexEngCols', 'lexEspCols', 'sylCols', 'blpCols', 'segCols']

#tempDir = startDir + '/temp_csv' # is there a way force the creation of this directory if it does not exist?

csvList = dataPreparation.collectFiles(parentDir,startDir) # create list of csv files to modify
# change the headers of csv files
# may have to change relative file path of json map file if you change folder structure
dataPreparation.reMapPandasHeaders('Dissertation_Stats/replacement_map.json',csvList,startDir,tempDir)

# get previously modified csv file as list
csvModList = dataPreparation.collectFiles(parentDir,tempDir)
# Eliminates all unnecessary columns written by PsychoPy
#print(csvModList)
dataPreparation.delPsyPyCols(csvModList,segKeepCols,tempDir, outDir)

# get previously modified csv file as list
csvTaskList = dataPreparation.collectFiles(parentDir,outDir)
#print(csvTaskList)
# Splits file into subsets for analysis and pastes them into temporary directory of stats
i = 0

for curList in listOfLists:
       listName = strListOfLists[i]
       dataPreparation.createAnalysisFiles(csvTaskList,listName, curList,outDir,statsSegDir)
       i += 1

'''
# get previously modified csv file as list
csvSplitList = dataPreparation.collectFiles(parentDir, statsSegDir)
# Eliminates all unnecessary columns written by PsychoPy
dataPreparation.delPsyPyCols(csvSplitList, sylCols, statsSegDir, statsOutDir)'''