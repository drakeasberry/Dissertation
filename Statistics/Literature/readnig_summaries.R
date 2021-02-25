# Load libraries
library(tidyverse)

# Load Tabled data
comps <- read_csv('input/comps_summary.csv')

# Cleaner
short_list <- comps %>% 
  select("Title", "Author", "Experiment", "Participant Language", 
         "Experiment Language", "Methodology", "Task", "Year") %>% 
  rename(Part_lang = "Participant Language",
         Exp_Lang = "Experiment Language")

# Analysis Times
#cut_off <- short_list %>% 
#  subset(., Methodology == 'Monitoring') %>% 
#  select("Author", "Experiment") %>% 
#  mutate("Min(ms)" = 9999, "Max(ms)" = 9999, "Removal(%)" = 9999, "Effect" = "No Data")
#write_csv(cut_off, "input/cut_off_times.csv")
cut_off <- read_csv('input/cut_off_times.csv')
