library(tidyverse)
library(janitor)
library(here)
library(lubridate)
library(rio)



# Load case numbers
# Use 7 day rolling average of all cases (confirmed and probable)
cases <- read_csv(here("data", "raw", "cases-by-day.csv")) %>% 
  clean_names() %>% 
  select(date_of_interest, all_case_count_7day_avg) %>% 
  rename(date = date_of_interest, cases = all_case_count_7day_avg) %>%
  mutate(date = as.Date(date, format = "%m/%d/%Y")) %>% 
  select(date, cases) 
 
# Load wastewater data
# Aggregate data by sample date and raw concentrations metric
wastewater <- read_csv(here("data", "raw", "SARS-CoV-2_concentrations_measured_in_NYC_Wastewater.csv")) %>% 
  clean_names() %>% 
  mutate(date = as.Date(sample_date, format = "%m/%d/%Y")) %>%
  rename(plant_name = wrrf_name, load = concentration_sars_co_v_2_gene_target_n1_copies_l, pop = population_served_estimated) %>% 
  select(date, plant_name, pop, annotation, load)

# There are hundreds of null values in the data, and annoations explain why that is 
annotations <- wastewater %>% 
  distinct(annotation)

# Based on conversations with Dave Larsen at Syracuse, we decided to handle null values in two ways
# 1. For annotations of null values with "Below Limit of Detection", we'll input 15, which is midway between 0 and lowest value in the data. These are the following annotations:
  #Concentration below Method Limit of Detection
  #Concentration below Method Limit of Detection - No signal in 1 out of 3 RT-qPCR wells, result is obtained by averaging signal from the two remaining RT-qPCR wells
  #Concentration below Method Limit of Detection - No signal is 2 out of 3 RT-qPCR wells, result in obtained by averaging signal from the remaining RT-qPCR well
  #Concentration below Method Limit of DetectionNo signal is 2 out of 3 RT-qPCR wells, result in obtained by averaging signal from the remaining RT-qPCR well
# 2. For all other null values, we'll input 0. 

wastewater_clean <- wastewater %>% 
  mutate(load = if_else(is.na(annotation), load,
                        # annoations with na aren't the problem, but we need to set this first so we don't create more NAs in the following lines of code 
                        if_else(annotation == "Concentration below Method Limit of Detection", 15, 
                        if_else(annotation == "Concentration below Method Limit of Detection - No signal in 1 out of 3 RT-qPCR wells, result is obtained by averaging signal from the two remaining RT-qPCR wells", 15, 
                        if_else(annotation == "Concentration below Method Limit of Detection - No signal is 2 out of 3 RT-qPCR wells, result in obtained by averaging signal from the remaining RT-qPCR well", 15,
                        if_else(annotation == "Concentration below Method Limit of DetectionNo signal is 2 out of 3 RT-qPCR wells, result in obtained by averaging signal from the remaining RT-qPCR well", 15, 
                        if_else(is.na(load), 0, load)))))))

# Now with the clean data, we'll sum total load for that day and divide by total population covered by the plants
wastewater_daily_avg <- 
  wastewater_clean %>% 
  group_by(date) %>% 
  summarize(total_pop = sum(pop), total_load = sum(load)) %>% 
  mutate(weighted_avg = total_load/total_pop)

# Create a csv with wastewater just 2022 for datawrapper
wastewater_daily_avg_2022 <- 
  wastewater_clean %>% 
  filter(date >= "2022-01-01") %>% 
  group_by(date) %>% 
  summarize(total_pop = sum(pop), total_load = sum(load)) %>% 
  mutate(weighted_avg = total_load/total_pop)

# Create a csv with cases just 2022 for datawrapper
cases_2022 <- cases %>% 
  filter(date >= "2022-01-01")


# Export the data for DataWrapper
export(wastewater_daily_avg,"data/processed/wasterwater_daily_avg.csv")
export(wastewater_daily_avg_2022,"data/processed/wasterwater_daily_avg_2022.csv")
export(cases, "data/processed/cases.csv")
export(cases_2022, "data/processed/cases_2022.csv")



