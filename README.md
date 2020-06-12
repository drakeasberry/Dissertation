# Dissertation Project for PhD in SLAT
## Cloning this repository

This repository uses submodules. To clone the entire repository and its submodules, please use the modified git clone command below:

`git clone --recurse-submodules https://github.com/drakeasberry/Dissertation.git`

If you cloned the repository using `git clone`, then you can still download the submodule content with the following commands:

First change directory into your git repository using the `cd` command followed by the path to your repository.
Then run:

`git submodule init && git submodule update` 

## Project Structure

**Asberry_Dissertation:** is the directory that contains all the Latex files to build dissertation document.
**Dissertation_Experiments:** is the directory that contains all PsychoPy experiment files and all condition files for experiments each in their own subdirectory.
- **lemma_version:** is an experiment converted for online use with Pavlovia after Null Hypothesis was found in `segmentation`and `lexicalAccess`experiments. This is currently host ed on gitlab for Pavlovia and is a `git submodule`.
- **lexicalAccess:** is an experiment ran locally using PsychoPy 3.0.7 between August 2019 and March 2020.
- **online_segmentation:** will be the online conversion of the `segmentation` experiment.
- **segmentation:** is an experiment ran locally using PscyhoPy 3.0.7 between August 2019 and March 2020.
**Scripts_Dissertation:** this contains scripts written that were reusable amongst different experiments in the dissertaiton project.
**Statistics:** this contains working files of data analysis from locally ran `lexicalAccess` and `segmentation` experiments.
- **Demographics:** contains analysis files and scripts for LexTALE-ESP, LexTALE-ENG and Binlingual Language Profile (BLP).
- **Inuition:** contains analysis files and scripts for syllable intuition from two option forced-choiced task.
- **Lexical_Access:** contains analysis files and scripts for lexical access experiment from a syllable masked-priming experiment.
- **Segmentation:** contains analysis files and scripts for segmenation experiment from a syllable monitoring task.

## Project Description/Log

This project set out to look at how different types of bilinguals of Spanish and English utilize the syllable in the processing of the Spanish language. One bilingual group was Spanish native speakers who learned English during schooling and were recruited from Hermosillo, MX. Group two consisted of English native speakers who learned Spanish during schooling and were recruited from Tucson, AZ. The third group was also recruited from Tucson, AZ and they attended school in English, but grew up speaking Spanish with their families. All tasks were visually presented to participants using PyschoPy on a MacBook Pro.

### LexTale-ESP
A vocabulary task where participants were asked to indicate whether or not a word presented on the screen was a real word of Spanish or not.

### LexTale-ENG
A vocabulary task where participants were asked to indicate whether or not a word presented on the screen was a real word of English or not.

### BIlingual Language Profile (BLP)
A survey developed by the University of Texas that consists of 19 questions to gain an understanding about a persons language history, use, proficiency and attitudes.

### Syllable Intuition
A task where participants were presented with a Spanish word and two options for the initial syllable of the word---one was a CV structure and the other was a CVC structure. The participants were not timed in this task, but they had to give an answer for every trial by selecting one of the two presented options as the initial syllable.

### Word Segmentation
The participants were shown a Spanish syllable and told to find the sequence of 2 or 3 letters in the sequence of letters (Spanish words or nonwords) that appeared on the screen. When the 2 or 3 letter sequence was not present, they were instructed to wait for the next word to appear on the screen. They were instructed to respond as fast as possible.

### Lexical Access
The participants saw a mask, #####, followed by a prime (CV or CVC syllable), followed by a word. The participants task was to say whether the word was a Spanish word or not as fast as possible. The prime could match or mismatch the initial syllable in the word or nonword.

## Current Status
For both the syllable intuition task and word segmentation experiment, sufficient amount of participants were collected from all three bilingual groups. The lexical access experiment did not have enough heritage speakers to consider as a separate group and data collection was cut short due to shutdowns from COVID-19. Participants from this group were dropped from analysis. All three groups did very on syllable intuition task, but the Spanish native group did stand out from the two groups recruited in Tucson, AZ. There were no other interactions or significant results from any experiment run. In the experiments ran up to this point, a latin square design was implemented so no participant saw an experimental item more than once. As we move to online, the idea is to A) run the same experiment with Spanish Monolingual to ensure there was not something wrong with experimental design or items (This would be indicated by finding a significant difference between the monolingual Spanish speakers and the groups previously tested AND B) create a new experiment `lemma_version`where every participant will see all conditions. For example, a word pairing balada-baldosa has four condidtions ba-BA.LA.DA, bal-BA.LA.DA, ba-BAL.DO.SA and bal-BAL.DO.SA. The nonword pair balega-balbusa has four conditions ba-BA.LE.GA, bal-BA.LE.GA, ba-BAL.BU.SA and bal-BAL.BU.SA. This will allow us to look at within participant during analysis stage for conditions, something we were unable to do given the latin-square design of the initial experiments.

Issues as they stand:
1. Designing online experiment with getting consent. Qualtrics?
2. Using Sliders
3. Mouse is staying visible even though box is unchecked in experiment
4. Getting random participant ID assigned as participants take experiment
5. In replciating the previous studies online with monolinguals, changing conditions for participant (Possibly best solution is create 4 separate experiments: 1 for condition A, 1 for B, 1 for C and 1 for D))
6. What encoding solution have used 'utf-8-sig' for special characters. (Happened to notice that you were the one that started github issue)

