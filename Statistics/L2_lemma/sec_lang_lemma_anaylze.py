# Prepare all files from Segmentation experiment and for R analysis
import os
from Scripts_Dissertation import data_preparation

# Set some constants
STARTFILECOUNT = 78


# Set some directory paths needed for project
project_wd = os.getcwd()
raw_part_dir = 'Dissertation_Experiments/sec_lang_lemma/data/original_data/part_files/'
temp_part_dir = 'Dissertation_Experiments/sec_lang_lemma/data/temp_data'
processed_part_dir = 'Dissertation_Experiments/sec_lang_lemma/data/processed_data/part_files'
stats_temp_dir = 'Statistics/L2_lemma/analyze_data/temp_data'
stats_out_dir = 'Statistics/L2_lemma/analyze_data/raw'
project_dir_list = [raw_part_dir, temp_part_dir, processed_part_dir, stats_temp_dir, stats_out_dir]

# Create lists for separate file needed to analyze all 5 experimental tasks
demo_cols = ['partNum', 'session', 'age', 'gender', 'birthCountry', 'placeResidence', 'education', 'preferLanguage',
           'date', 'expName', 'OS', 'houseLanguage', 'raisedCountry', 'first_learning', 'speaking', 'listening',
             'reading', 'writing', 'last_class']
lextale_duplicates = ['lex_pres_order', 'word', 'translation']
lextale_esp = ['corrAnsEspV', 'lextaleRespEsp', 'lextaleRespEspCorr', 'lextaleRespEspRT']
#lextale_eng = ['corrAnsEngV', 'lextaleRespEng', 'lextaleRespEngCorr', 'lextaleRespEngRT']
#syl = ['syllabification', 'corrSyl', 'corrAns', 'leftKey', 'rightKey', 'condition', 'sylResp', 'sylRespCorr',
#       'sylRespRT', ]
#blp = ['questionNum', 'color', 'sectionEng', 'questionTextEng', 'languageEng', 'langHistResp1', 'langHistRT1',
#       'langHistResp2', 'langHistRT2', 'langHistResp', 'langHistRT', 'langUseResp', 'langUseRT', 'langProfResp',
#       'langProfRT', 'langAttResp', 'langAttRT']
seg = ['fillerCarrier', 'segResp', 'segRespRT', 'exp_pres_order', 'block', 'expWord', 'wd_int_syl_str',
       'tar_syl_str', 'tar_syl', 'wd_status', 'matching', 'lemma', 'first_3', 'item_type', 'segRespCorr', 'corrAns']
lextale_esp_cols = [*lextale_duplicates, *lextale_esp, *demo_cols]
#lextale_eng_cols = [*lextale_duplicates, *lextale_eng, *demo_cols]
#syl_cols = [*syl, *demo_cols]
#blp_cols = [*blp, *demo_cols]
seg_cols = [*seg, *demo_cols]
seg_keep_cols = [*lextale_duplicates, *lextale_esp, *seg_cols, *demo_cols]
list_of_lists = {'lextale_esp_cols':lextale_esp_cols, 'seg_cols':seg_cols}

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
# Check for valid data files
valid_df = []
invalid_df = []
empty_df = []

for file in csv_list:
    try:
        df = data_preparation.read_pandas(raw_part_dir,file,False)
        print(df.size)
        if df.size == 66850:
            valid_df.append(file)
        else:
            invalid_df.append(file)
    except:
        empty_df.append(file)

# remove participants from analysis
# Questioned but verified and kept
# part255 kept because they overwrote Estados Unidos with U.S, inglés with English for house and preferred language
# part256 kept because they reported ambos for house language and preferred language as inglés, learned Spanish at 11
# part262 kept because they reported ambos for house language and preferred language as español, learned Spanish at 12
# part266 kept because they reported ambos for house language and preferred language as inglés, learned Spanish at 16
# part268 kept because they reported preferred language as español, learned Spanish at 18
# part274 kept because they reported ambos for house language and preferred language as inglés, learned Spanish at 15
# part280 kept because they overwrote Estados Unidos with U.S, inglés with English for house and preferred language
# part293 kept because they reported ambos for house language and preferred language as inglés, learned Spanish at 5
# part295 kept because they reported ambos for house language and preferred language as inglés, learned Spanish at 10
# part297 kept because they reported ambos for house language and preferred language as inglés, learned Spanish at 11
# part302 kept because they reported ambos for house language and preferred language as inglés, learned Spanish at 26
# part308 kept because they reported ambos for house language and preferred language as inglés, learned Spanish at 12
# part332 kept because reported ambos for house language, preferred language as inglés, learned Spanish after marriage

# Dropped
# part259 dropped because they are fluent in Korean as well
valid_df.remove('part259_lemma_segmentation_2020-07-17_15h32.23.667.csv')
# part263 dropped because they are fluent in French as well
valid_df.remove('part263_lemma_segmentation_2020-07-17_16h34.01.316.csv')
# part267 dropped because they reported being raised in Mexico, preferred and house language español
valid_df.remove('part267_lemma_segmentation_2020-07-18_00h34.00.643.csv')
# part280 dropped for high filler error, check to see if code can do it
valid_df.remove('part280_lemma_segmentation_2020-07-17_19h01.55.230.csv')
# part284 dropped for not being a native English speaker
valid_df.remove('part284_lemma_segmentation_2020-07-17_19h44.00.293.csv')
# part287 dropped because they reported knowing French and Italian as well
valid_df.remove('part287_lemma_segmentation_2020-07-22_16h57.24.518.csv')
# part294 dropped because they reported knowing Italian as well
valid_df.remove('part294_lemma_segmentation_2020-07-22_19h44.45.764.csv')
# part315 dropped because reported being born outside US
valid_df.remove('part315_lemma_segmentation_2020-07-24_11h40.37.219.csv')
# part333 dropped because reported being raised in Mexico
valid_df.remove('part333_lemma_segmentation_2020-07-29_08h45.17.314.csv')

REMOVELIST = len(invalid_df) + len(empty_df)
FILECOUNTAFTERREMOVAL = STARTFILECOUNT - REMOVELIST - 9
assert len(valid_df) == FILECOUNTAFTERREMOVAL

# change the headers of csv files
data_preparation.remap_pandas_headers('Scripts_Dissertation/replacement_map.json', valid_df, raw_part_dir, temp_part_dir, False)

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
exp_search_directory = 'Dissertation_Experiments/sec_lang_lemma/data/processed_data/exp_files'
analyze_dir = 'Statistics/L2_lemma/analyze_data'

# get join files containing word frequency data
excel_wb = 'Dissertation_Experiments/sec_lang_lemma/Online_Segmentation_Experimental_Item_Setup.xls'
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
print(sorted(empty_df))
print(sorted(invalid_df))
print(sorted(valid_df))
print('%d contain all expected data \n %d were incomplete \n %d were empty' % (len(valid_df), len(invalid_df) ,len(empty_df)))




