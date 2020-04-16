# Prepare all files from experiment and for R analysis
import os
import glob
from Scripts_Dissertation import data_preparation

# Set some directory paths needed for project
parent_dir = os.getcwd()
original_dir = 'Dissertation_Experiments/lexicalAccess/data/original_data/part_files/'
temp_dir = 'Dissertation_Experiments/lexicalAccess/data/temp_data'
processed_dir = 'Dissertation_Experiments/lexicalAccess/data/processed_data/part_files'
stats_temp_dir = 'Statistics/Lexical_Access/analyze_data/temp_data'
stats_out_dir = 'Statistics/Lexical_Access/analyze_data'
directory_list = [original_dir, temp_dir, processed_dir, stats_temp_dir, stats_out_dir]

# Create lists for separate file needed to analyze all experiments
demo_cols = ['partNum', 'session', 'age', 'gender', 'birthCountry', 'placeResidence', 'education', 'preferLanguage',
           'date', 'expName']
lextale_duplicates = ['word', 'translation', 'corrAns']
lextale_esp = ['lextaleRespEsp', 'lextaleRespEspCorr', 'lextaleRespEspRT']
lextale_eng = ['lextaleRespEng', 'lextaleRespEngCorr', 'lextaleRespEngRT']
syl = ['syllabification', 'corrSyl', 'corrAns', 'leftKey', 'rightKey', 'condition', 'sylResp', 'sylRespCorr',
       'sylRespRT', ]
blp = ['questionNum', 'color', 'sectionEng', 'questionTextEng', 'languageEng', 'langHistResp1', 'langHistRT1',
       'langHistResp2', 'langHistRT2', 'langHistResp', 'langHistRT', 'langUseResp', 'langUseRT', 'langProfResp',
       'langProfRT', 'langAttResp', 'langAttRT']
lexical = ['Word', 'corrAns', 'initialSylStress', 'sylStruc', 'wordStatus', 'freq_WPM', 'numRevealed', 'Prime', 'matching', 'lexicalResp', 'lexicalRespCorr', 'lexicalRespRT',]
lextale_esp_cols = [*lextale_duplicates, *lextale_esp, *demo_cols]
lextale_eng_cols = [*lextale_duplicates, *lextale_eng, *demo_cols]
syl_cols = [*syl, *demo_cols]
blp_cols = [*blp, *demo_cols]
lexical_cols = [*lexical, *demo_cols]
lexical_keep_cols = [*lextale_duplicates, *lextale_esp, *lextale_eng, *syl_cols, *lexical_cols, *blp_cols, *demo_cols]
list_of_lists = {'lextale_eng_cols':lextale_eng_cols, 'lextale_esp_cols':lextale_esp_cols, 'syl_cols':syl_cols, 'blp_cols':blp_cols, 'lexical_cols':lexical_cols}

# create directory structure for project
for directory in directory_list:
    data_preparation.create_directory(directory)

# create list of csv files to modify and rename headers
csv_list = data_preparation.collect_files(parent_dir, original_dir, '*.csv')
#print(csv_list)

# change the headers of csv files
data_preparation.remap_pandas_headers('Scripts_Dissertation/replacement_map.json', csv_list, original_dir, temp_dir)

# get list of csv files to modify and select desired columns
csv_list_new_headers = data_preparation.collect_files(parent_dir, temp_dir, '*.csv')

# Eliminates all unnecessary columns written by PsychoPy
data_preparation.del_psycopy_cols(csv_list_new_headers, lexical_keep_cols, temp_dir, processed_dir)

# get list of csv files to modify, splits files and moves to stats temporary directory
csv_list_to_split = data_preparation.collect_files(parent_dir, processed_dir, '*.csv')

# moved list creation for skipped files out of loop HERE IS BEST I THINK
print(os.getcwd())
os.chdir('Dissertation_Experiments/lexicalAccess/data/processed_data/part_files/')
skip_files = glob.glob('*_No_Lexical_Access.csv')
print(skip_files)
os.chdir(parent_dir)

# Splits file into subsets for analysis and pastes them into temporary directory of stats
for cur_list in list_of_lists:
    list_name = list_of_lists.get(cur_list)
    #print(csv_list_to_split) # prints out list of filenames associated with query
    #print(cur_list) # prints list name
    #print(list_name) # prints out column names to keep
    #print(processed_dir) # prints directory path that data is pulled from
    #print(stats_temp_dir) # prints directory path that data is written to
    data_preparation.create_analysis_directories(skip_files, csv_list_to_split, cur_list, list_name, processed_dir, stats_temp_dir)

# creates subdirectories in rFiles directory for each experiment with subset files ready for rStudio import
for cur_list in list_of_lists:
    list_name = list_of_lists.get(cur_list)
    list_dir = stats_temp_dir + '/' + cur_list
    #print('parent directory: ', parent_dir)
    #print('list directory: ', list_dir)
    csv_list_to_subset = data_preparation.collect_files(parent_dir, list_dir, '*.csv')
    #print(csv_list_to_split)
    data_preparation.create_analysis_files(csv_list_to_subset, cur_list, list_dir, parent_dir)


