
# load size data
size.raw_df <- read_csv('../experiments/size/data/jatos_results_data_without_pixel_data.csv') %>%
  mutate(subj_id=PROLIFIC_PID,
         correct = as.numeric(as.logical(correct)),
         RT=as.numeric(RT),
         confidence=as.numeric(confidence),
         present=as.numeric(present),
         resp = response == presence_key,
         size=factor(ifelse(pixel_size_factor=='3','small','big'),levels=c('big','small')))

# subject exclusion
size.low_accuracy <- size.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    accuracy = mean(correct)) %>%
  filter(accuracy<0.5) %>%
  pull(subj_id)

size.too_slow <- size.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    third_quartile_RT = quantile(RT,0.75)) %>%
  filter(third_quartile_RT>7000) %>%
  pull(subj_id)

size.too_fast <- size.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    first_quartile_RT = quantile(RT,0.25)) %>%
  filter(first_quartile_RT<100) %>%
  pull(subj_id)

size.to_exclude <- c(
  size.low_accuracy,
  size.too_slow,
  size.too_fast
) %>% unique()

size.df <- size.raw_df %>%
  filter(!(subj_id %in% size.to_exclude) & !is.na(subj_id)) %>%
  mutate(size=factor(size,levels=c('small','big')),
         subj_id = as.numeric(as.factor(subj_id))) 

size.df_for_model_fitting <- size.df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  filter(RT<7000 & RT>100) %>%
  mutate(rt = RT/1000, 
         present = ifelse(present==0,-1,present),
         easy = ifelse(size=='small',1,0)) %>%
  dplyr::select(subj_id,rt,confidence,correct,present,easy)

write_csv(size.df_for_model_fitting,'../model/data/E_size.csv')

prospective.raw <- read.csv("../experiments/prospective/data/jatos_results_data_without_pixel_data.csv", header=TRUE) %>%
  # dplyr::select(-presented_pixel_data) %>%
  dplyr::mutate(
    subj_id = PROLIFIC_PID,
    correct = as.numeric(as.logical(correct)),
    RT = as.numeric(RT),
    confidence = as.numeric(confidence),
    present = as.numeric(present),
    resp = response == presence_key,
    size = factor(ifelse(pixel_size_factor == '3', 'small', 'big'), levels = c('big', 'small'))
  ) %>%
  filter(!(subj_id %in% c('PROLIFIC_PID', '')))

prospective.comments.df <- prospective.raw %>%
  dplyr::filter(trial_type == 'survey-text') %>%
  dplyr::select(response)

prospective.df <- prospective.raw %>%
  dplyr::filter(test_part == 'test1') %>%
  dplyr::select(subj_id, size, confidence, correct, RT, confidence_time, confidence_RT, present, resp, target)

# data exclusions 

prospective.low_accuracy <- prospective.df %>% 
  group_by(subj_id) %>%
  dplyr::summarise(correct=mean(correct)) %>%
  dplyr::filter(correct<0.5) %>%
  dplyr::pull(subj_id)

prospective.too_slow <- prospective.df %>%
  group_by(subj_id) %>%
  dplyr::summarise(
    third_quartile_RT = quantile(RT,0.75)) %>%
  dplyr::filter(third_quartile_RT>7000) %>%
  dplyr::pull(subj_id)

prospective.too_fast <- prospective.df %>%
  group_by(subj_id) %>%
  dplyr::summarise(
    first_quartile_RT = quantile(RT,0.25)) %>%
  dplyr::filter(first_quartile_RT<100) %>%
  dplyr::pull(subj_id)

prospective.to_exclude <- c(
  prospective.low_accuracy,
  prospective.too_slow,
  prospective.too_fast
) %>% unique()

prospective.df <- prospective.df %>%
  dplyr::filter(!(subj_id %in% prospective.to_exclude))