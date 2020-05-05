# Prepare all files from Segmentation experiment and for R analysis
import os
from Scripts_Dissertation import data_preparation

# Set some constants
STARTFILECOUNT = 77
FILECOUNTAFTERREMOVAL = STARTFILECOUNT - 3

# Set some directory paths needed for project
project_wd = os.getcwd()
raw_part_dir = 'Dissertation_Experiments/segmentation/data/original_data/part_files/'
temp_part_dir = 'Dissertation_Experiments/segmentation/data/temp_data'
processed_part_dir = 'Dissertation_Experiments/segmentation/data/processed_data/part_files'
stats_temp_dir = 'Statistics/Segmentation/analyze_data/temp_data'
stats_out_dir = 'Statistics/Segmentation/analyze_data/raw'
project_dir_list = [raw_part_dir, temp_part_dir, processed_part_dir, stats_temp_dir, stats_out_dir]

# Create lists for separate file needed to analyze all 5 experimental tasks
demo_cols = ['partNum', 'session', 'age', 'gender', 'birthCountry', 'placeResidence', 'education', 'preferLanguage',
           'date', 'expName']
lextale_duplicates = ['word', 'translation']
lextale_esp = ['corrAnsEspV', 'lextaleRespEsp', 'lextaleRespEspCorr', 'lextaleRespEspRT']
lextale_eng = ['corrAnsEngV', 'lextaleRespEng', 'lextaleRespEngCorr', 'lextaleRespEngRT']
syl = ['syllabification', 'corrSyl', 'corrAns', 'leftKey', 'rightKey', 'condition', 'sylResp', 'sylRespCorr',
       'sylRespRT', ]
blp = ['questionNum', 'color', 'sectionEng', 'questionTextEng', 'languageEng', 'langHistResp1', 'langHistRT1',
       'langHistResp2', 'langHistRT2', 'langHistResp', 'langHistRT', 'langUseResp', 'langUseRT', 'langProfResp',
       'langProfRT', 'langAttResp', 'langAttRT']
seg = ['fillerCarrier', 'block01', 'block02', 'block03', 'block04', 'block05', 'block06', 'block07', 'block08',
       'block09', 'block10', 'block11', 'block12', 'block13', 'block14', 'block15', 'block16', 'block17', 'block18',
       'block19', 'block20', 'block21', 'block22', 'block23', 'block24', 'block25', 'block26', 'block27', 'block28',
       'block29', 'block30', 'block31', 'block32', 'block33', 'block34', 'block35', 'block36', 'block37', 'block38',
       'block39', 'block40', 'block41', 'block42', 'block43', 'block44', 'block45', 'block46', 'block47', 'block48',
       'segResp', 'segRespRT']
lextale_esp_cols = [*lextale_duplicates, *lextale_esp, *demo_cols]
lextale_eng_cols = [*lextale_duplicates, *lextale_eng, *demo_cols]
syl_cols = [*syl, *demo_cols]
blp_cols = [*blp, *demo_cols]
seg_cols = [*seg, *demo_cols]
seg_keep_cols = [*lextale_duplicates, *lextale_esp, *lextale_eng, *syl_cols, *seg_cols, *blp_cols, *demo_cols]
list_of_lists = {'lextale_eng_cols':lextale_eng_cols, 'lextale_esp_cols':lextale_esp_cols, 'syl_cols':syl_cols, 'blp_cols':blp_cols, 'seg_cols':seg_cols}

path = os.getcwd()
print('The starting working directory is %s: ' % path)
# create directory structure for project
for directory in project_dir_list:
    data_preparation.create_directory(directory)
    print(directory)
    #data_preparation.clear_old_files(directory,'.csv')

# create list of csv files to modify and rename headers
csv_list = data_preparation.collect_files(project_wd, raw_part_dir, '*.csv')

assert len(csv_list) == STARTFILECOUNT
# remove participants from analysis
#try:
csv_list.remove('part044_inglés_C_Segmentation.csv') # removed for fluency in other languages
csv_list.remove('part047_español_D_Segmentation.csv') # removed for different Spanish variety (geographic location)
csv_list.remove('part052_inglés_D_Segmentation.csv') # removed for birth country
#except: ValueError
# not a great programming standard (ask Julian later) probably not needed
assert len(csv_list) == FILECOUNTAFTERREMOVAL

# change the headers of csv files
data_preparation.remap_pandas_headers('Scripts_Dissertation/replacement_map.json', csv_list, raw_part_dir, temp_part_dir, 0)

# get list of csv files to modify and select desired columns
csv_list_new_headers = data_preparation.collect_files(project_wd, temp_part_dir, '*.csv')

# assert columns before
# Eliminates all unnecessary columns written by PsychoPy
data_preparation.del_psycopy_cols(csv_list_new_headers, seg_keep_cols, temp_part_dir, processed_part_dir, 0)
# assert columns after

# assert length (74)
# get list of csv files to modify, splits files and moves to stats temporary directory
csv_list_to_split = data_preparation.collect_files(project_wd, processed_part_dir, '*.csv')
# assert length (74)

skip_files = [] # will always be empty for segmentation experiment because no one returned to lab for second time

# Splits file into subsets for analysis and pastes them into temporary directory of stats
for cur_list in list_of_lists:
    list_name = list_of_lists.get(cur_list)
    #print(csv_list_to_split) # prints out list of filenames associated with query
    #print(cur_list) # prints list name
    #print(list_name) # prints out column names to keep
    #print(processed_part_dir) # prints directory path that data is pulled from
    #print(stats_temp_dir) # prints directory path that data is written to
    data_preparation.create_analysis_directories(skip_files, csv_list_to_split, cur_list, list_name, processed_part_dir, stats_temp_dir, 0)

# assert list out files and make sure number of files equals what I think

# creates subdirectories in rFiles directory for each experiment with subset files ready for rStudio import
for cur_list in list_of_lists:
    list_name = list_of_lists.get(cur_list)
    list_dir = stats_temp_dir + '/' + cur_list
    csv_list_to_subset = data_preparation.collect_files(project_wd, list_dir, '*.csv')
    output_files = data_preparation.create_analysis_files(csv_list_to_subset, cur_list, list_dir, project_wd, 0)
    print(output_files)
    assert len(output_files) == FILECOUNTAFTERREMOVAL

# paths needed to create join tables
exp_search_directory = 'Dissertation_Experiments/segmentation/data/processed_data/exp_files'
analyze_dir = 'Statistics/Segmentation/analyze_data'

# get join files containing word frequency data
excel_wb = 'Dissertation_Experiments/segmentation/Segmentation_Experimental_Item_Setup.xlsx'
sheet_names = ['Critical_Items', 'RW_Filler_Items','PW_Filler_Items']

for sheet in sheet_names:
    out_file = analyze_dir + '/' + sheet + '.csv'
    data_preparation.csv_from_excel(excel_wb, sheet, out_file)


# create join table from experiment files
exp_file_list = data_preparation.collect_files(project_wd, exp_search_directory, 'exp*')
data_preparation.copy_files(exp_file_list, exp_search_directory, analyze_dir)

# remap headers and move to new directory
join_csv_list = data_preparation.collect_files(project_wd, analyze_dir, '*.csv')
data_preparation.remap_pandas_headers('Scripts_Dissertation/replacement_map.json',
                                      join_csv_list, analyze_dir, analyze_dir, False)

# sanity check
# each file directory
    # number of files directory
    # number of lines in each file

# hard coded subset check (write script to automate check)

# Find a raw data and compare with their results 






