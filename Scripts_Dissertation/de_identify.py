import dataPreparation
import os

parentDir = os.getcwd()
startDir = 'Dissertation_Experiments/segmentation/data/original_data/part_files/'
dropList = ["03_Nombre (First name):","04_Apellido (Last name):"]

csvList = dataPreparation.collectFiles(parentDir,startDir) # create list of csv files to deidentify
dataPreparation.deIndentify(csvList,dropList,startDir,startDir) # currently keeping only the columns I need to drop