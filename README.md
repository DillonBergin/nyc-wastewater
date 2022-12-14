# Analysis of New York City COVID-19 Case and Wastewater Data from 2020 to Novemeber 2022

This repository contains data that supports findings and visualizations in the article [Wastewater can predict COVID-19 surges, but NYC’s data remains elusive](link) published by WNYC/Gothamist and MuckRock on December 15, 2022. 


# Data and Methodology
In 2022, fewer New Yorkers sought out PCR testing for COVID-19 as at-home tests became more widely available and many city testing sites closed. Official case data – which relies on these swabs – is now a significant undercount of true infections in the city. We used [official case data](https://github.com/DillonBergin/nyc_wastewater/blob/main/data/raw/cases-by-day.csv) from the [New York City Department of Health and Mental Hygiene](https://github.com/nychealth/coronavirus-data), and chose a to visualize a seven-day rolling average of cases used to highlight trends. 

Since August 2020, the Department of Environmental Protection has sampled New York City’s 14 wastewater treatment plants twice a week to test for the coronavirus in the sewage. As this testing includes all New Yorkers – not just those who seek out PCR testing – experts consider it a more accurate reflection of disease spread, especially as testing became less popular in 2022. 

Wastewater data in our analysis [come from the city's open data portal](https://data.cityofnewyork.us/Health/SARS-CoV-2-concentrations-measured-in-NYC-Wastewat/f7dc-2q9f/) and are standardized by population of the 14 plants to [provide a city-wide trend](https://github.com/DillonBergin/nyc_wastewater/blob/main/data/processed/wasterwater_daily_avg.csv). 


# Questions / Feedback
Contact Dillon Bergin at dillon@muckrock.com or Betsy Ladyzhets at betsy@muckrock.com 
