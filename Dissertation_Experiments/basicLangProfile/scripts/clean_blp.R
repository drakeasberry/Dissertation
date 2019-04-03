# clean working directory
rm(list = ls(all = TRUE))

# Set working directory
setwd("~/code/psychopy/psychopy_templates/blp")

library(tidyverse)


# Combine files vertically into large data frame
temp <- list.files(path = "./data", full.names = TRUE, pattern = ".csv")
myfiles = lapply(temp, read.csv, sep = ",")
df <- do.call("rbind", myfiles)

glimpse(df)

lang_hist_df <- df %>% filter(., section == 'Language history') %>% 
  select(., participant, 
            date, 
            country, 
            age, 
            gender, 
            highestEd = 'highest.level.of.ed', 
            residence = 'place.of.residence', 
            section, 
            language, 
            questionNum, 
            rating = 'rating_lang_hist.response'
            )

lang_use_df <- df %>% filter(., section == 'Language use') %>% 
  select(., participant, 
            date, 
            country, 
            age, 
            gender, 
            highestEd = 'highest.level.of.ed', 
            residence = 'place.of.residence', 
            section, 
            language, 
            questionNum, 
            rating = 'rating_lang_use.response'
            )

lang_prof_df <- df %>% filter(., section == 'Language proficiency') %>% 
  select(., participant, 
            date, 
            country, 
            age, 
            gender, 
            highestEd = 'highest.level.of.ed', 
            residence = 'place.of.residence', 
            section, 
            language, 
            questionNum, 
            rating = 'rating_lang_prof.response'
            )

lang_att_df <- df %>% filter(., section == 'Language attitudes') %>% 
  select(., participant, 
            date, 
            country, 
            age, 
            gender, 
            highestEd = 'highest.level.of.ed', 
            residence = 'place.of.residence', 
            section, 
            language, 
            questionNum, 
            rating = 'rating_lang_att.response'
            )

blp_temp_df <- bind_rows(lang_hist_df, lang_use_df, lang_prof_df, lang_att_df)




# Step 1 : Module Scores

# Within each module, tally the point totals for each language 
# separately based on the following guidelines. This will yield 
# the language particular score for each module.

# Language History

# 6 questions: each worth between 0 and 20
# Each item is worth the numerical value given 
# in the response, with three exceptions:
#    1. The first two items are scored in the 
#       reverse: A “20” response is worth 0, 
#       a “19” is worth 1, and so on
#    2. Phrasal responses “Since birth” and 
#       “For as long as I can remember” are 
#       worth 20 points
#    3. “Not yet” is worth 0 points

# Reverse code 1ab and 2ab
blp_temp_df[blp_temp_df$questionNum == '1a', 'rating'] <- 20 - blp_temp_df[blp_temp_df$questionNum == '1a', 'rating']
blp_temp_df[blp_temp_df$questionNum == '1b', 'rating'] <- 20 - blp_temp_df[blp_temp_df$questionNum == '1b', 'rating']
blp_temp_df[blp_temp_df$questionNum == '2a', 'rating'] <- 20 - blp_temp_df[blp_temp_df$questionNum == '2a', 'rating']
blp_temp_df[blp_temp_df$questionNum == '2b', 'rating'] <- 20 - blp_temp_df[blp_temp_df$questionNum == '2b', 'rating']



# Language Use

# 5 questions: each worth between 0 and 100
# Each item is worth the numerical value given 
# in the response

# Language Proficiency

# 4 questions: each worth between 0 and 6
# Each item is worth the numerical value given 
# in the response

# Language Attitudes

# 4 questions: each worth between 0 and 6
# Each item is worth the numerical value given 
# in the response







# Step 2 : Global Language Scores

# To ensure that each module receives equal weighting 
# in the global language score, multiply the score for 
# each module (each language calculated separately) by 
# a factor of:

#   - Language History:     0.454
#   - Language Use:         1.09
#   - Language Proficiency: 2.27
#   - Language Attitudes:   2.27

# Add the new module totals together to yield a global 
# score for each language. 
# Total points possible is 218.

hist_hold <- blp_temp_df %>% 
  filter(., section == 'Language history') %>%
  group_by(., participant, date, country, age, gender, highestEd, residence, section, language) %>% 
  summarize(., score = sum(rating) * 0.454) %>% 
  ungroup(.) %>% as.data.frame



use_hold <- blp_temp_df %>% 
  filter(., section == 'Language use') %>%
  group_by(., participant, date, country, age, gender, highestEd, residence, section, language, ) %>% 
  summarize(., score = mean(rating) * 1.09) %>% 
  ungroup(.)



prof_hold <- blp_temp_df %>% 
  filter(., section == 'Language proficiency') %>%
  group_by(., participant, date, country, age, gender, highestEd, residence, section, language, ) %>% 
  summarize(., score = mean(rating) * 2.27) %>% 
  ungroup(.)



att_hold <- blp_temp_df %>% 
  filter(., section == 'Language attitudes') %>%
  group_by(., participant, date, country, age, gender, highestEd, residence, section, language, ) %>% 
  summarize(., score = mean(rating) * 2.27) %>% 
  ungroup(.)



blp_mod <- bind_rows(hist_hold, use_hold, prof_hold, att_hold)


# STOPPED HERE

blp_mod <- blp_mod %>% 
  group_by(., Apellidos) %>% 
  summarise(., english = sum(english), 
               spanish = sum(spanish))

# Step 3 : Dominance Score

# To obtain the language dominance index, subtract one 
# language total from the other to render a dominance score 
# that ranges from -218 to +218. A score near zero indicates 
# balanced bilingualism and more positive or more negative scores 
# reflect respective language dominance.

blp_dominance <- blp_mod %>% 
  mutate(., dominance = english - spanish)


blp_dominance %>% 
  ggplot(., aes(x = Apellidos, y = dominance, label = Apellidos)) + 
    geom_text()

blp_dominance %>% 
  ggplot(., aes(x = dominance)) + 
    geom_histogram()

blp_dominance %>% 
  ggplot(., aes(x = 0, y = dominance)) + 
    geom_boxplot() + 
    xlim(-0.5, 0.5) + 
    stat_summary(fun.y = mean, geom = 'point', size = 3, color = 'red') + 
    coord_flip() + 
    theme_bw()

blp_dominance %>% 
  ggplot(., aes(x = english, y = spanish, label = Apellidos)) + 
    geom_text() + 
    geom_smooth(method = 'lm')


blp_dominance %>% 
  summarise(., mean = mean(dominance), 
               sd = sd(dominance), 
               median = median(dominance))

blp_dominance %>% 
  arrange(., dominance) %>% as.data.frame

blp_dominance %>% 
  filter(., dominance >= -42 & dominance <= 29) %>%
  summarise(., mean = mean(dominance), 
               sd = sd(dominance), 
               median = median(dominance))

blp_dominance %>% 
  filter(., dominance >= -42 & dominance <= 29) %>%
  ggplot(., aes(x = 0, y = dominance)) + 
    geom_boxplot() + 
    xlim(-0.5, 0.5) + 
    stat_summary(fun.y = mean, geom = 'point', size = 3, color = 'red') + 
    coord_flip() + 
    theme_bw()