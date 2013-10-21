stat545a-2013-hw06_lee-woo
==========================

stat545a homework 6 submitted by Wooyong Lee.

**Contents:**
- [Description of the raw data](https://github.com/folias/stat545a-2013-hw06_lee-woo#description-of-the-raw-data)
- [Objective of the analysis and the work flow](https://github.com/folias/stat545a-2013-hw06_lee-woo#objective-of-the-analysis-and-the-work-flow)
- [Details of the study: overview](https://github.com/folias/stat545a-2013-hw06_lee-woo#details-of-the-study-overview)
- [Details of the study: Step 1 - data cleaning and manipulation](https://github.com/folias/stat545a-2013-hw06_lee-woo#details-of-the-study-step-1---data-cleaning-and-manipulation)
- [Details of the study: Step 2 - creation of plots](https://github.com/folias/stat545a-2013-hw06_lee-woo#details-of-the-study-step-2---creation-of-plots)

## Description of the raw data

There are two datasets used in this homework.

List of datasets and their sources:

- [`Unemp_Duration.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration.csv) : 
 OECD (2010), "Labour Market Statistics: Unemployment by duration", 
 *OECD Employment and Labour Market Statistics (database)*. 

 This dataset contains annual unemployment data for OECD member countries from 2000 to 2012.
 (I don't know why it contains data in 2011 and 2012, but there are data points.)
 For each country and for each year, the number of unemployed people are recorded according to the duration of
 unemployment. The data are segmentalized according to sex and standardized age groups.
 [Link to the dataset webpage] (http://dx.doi.org/10.1787/data-00320-en)

- [`Unemp_LaborForce.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_LaborForce.csv) : 
 OECD (2010), "Labour Market Statistics: Labour force statistics by sex and age", 
 *OECD Employment and Labour Market Statistics (database)*. 

 This dataset contains annual labor force(the number of people who are available for work) data for 
 OECD member countries from 2000 to 2012.
 (I don't know why it contains data in 2011 and 2012, but there are data points.)
 For each country and for each year, population, labor force, the number of employed and umemployed people are recorded. 
 The data are segmentalized according to sex and standardized age groups.
 [Link to the dataset webpage](http://dx.doi.org/10.1787/data-00309-en)


[`Unemp_Duration.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration.csv) is
a main dataset of interest, and 
[`Unemp_LaborForce.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_LaborForce.csv) is
used as a supplementary dataset required for the analysis of 
[`Unemp_Duration.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration.csv).
Data manipulation can be done via OECD database tool, but all options are set as default for the data cleaning exercise.

List of variables are as follows. Levels for categorical variables are in the parentheses.

- [`Unemp_Duration.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration.csv)
  - **Sex**: gender group (male, female or all persons)
  - **Age**: standardised age groups (15-19, 15-24, 20-24, 25-54, 55+, total)
  - **Frequency**: Frequency of observations (Monthly, Quarterly, Annual, etc. For the datasets I use, only annual data is available)
  - **Country**: countries. (OECD member countries + some aggregate data such as data for OECD countries, G7 countries,
    European countries, etc)
  - **Duration**: duration of unemployment.  ( < 1 month, > = 1 month and < 3 months, > = 3 months and < 6 months, > = 6 months and <1 year, 1 year and over, total declared)
  - **Time**: Time of the record. (2000, 2001, ..., 2012)
  - **Value**: the number of unemployed people (numeric, unit: thousands of persons)

- [`Unemp_LaborForce.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_LaborForce.csv)
  - **Series**: type of the record (population, labor force, employment, unemployment)
  - **Sex**: gender group (male, female or all persons)
  - **Age**: standardised age groups (15-24, 25-54, 55-64, 65+, total)
  - **Frequency**: Frequency of observations (Monthly, Quarterly, Annual, etc. For the datasets I use, only annual data is available)
  - **Country**: countries. (OECD member countries + some aggregate data such as data for OECD countries, G7 countries,
    European countries, etc)
  - **Time**: Time of the record. (2000, 2001, ..., 2012)
  - **Value**: the number of people that fits into the value of Series (numeric, unit: thousands of persons)

  



## Objective of the analysis and the work flow

**Objective:** Take a look at the impact of Subprime Mortgage Financial Crisis 
([Wikipedia page for Subprime Financial Crisis](http://en.wikipedia.org/wiki/Subprime_mortgage_crisis))
on OECD countries in terms of the unemployment rate by visualizing the data.

**Overall work flow:**

1. perform a data cleaning and a data manipulation, and produce a well-organized data for the next step.
2. provide plots based on the data prepared in the first step.

  



## Details of the study: overview

- Input files:
  [`Unemp_Duration.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration.csv)
  and
  [`Unemp_LaborForce.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_LaborForce.csv)
- An R code that rules all the procedure: 
  [`Makefile.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Makefile.R)
  - R codes required to run [`Makefile.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Makefile.R):
  [`00_removeOutputs.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/00_removeOutputs.R),
  [`01_filterReorder.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/01_filterReorder.R) and
  [`02_aggregatePlot.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/02_aggregatePlot.R)
- Outputs:
  - [`Unemp_Duration_Cleaned.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration_Cleaned.csv)
    : a cleaned and manipulated dataset
  - [`barchart_2012_AggregateUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/barchart_2012_AggregateUnempRate.png)
    : unemployement rate of countries in 2012.
  - [`barchart_2012_AgewiseUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/barchart_2012_AgewiseUnempRate.png)
    : agewise unemployement rate of countries in 2012.
    By agewise unemployment rate, I mean the ratio of the number of unemployed people in a age group to
    labor force in the age group, that is, the number of people who are available for work in the age group.
  - `areaplot_GenderwiseUnempRate_COUNTRY.png`
    : an areaplot of genderwise unemployment rate over the years for COUNTRY, gridded by gender, 
    where COUNTRY is one of: Canada, Denmark, Estonia, Germany, Greece, Ireland, Spain, Turkey and United States.
    By genderwise unemployment rate, I mean the ratio of the number of unemployed men/women to
    labor force of men/women, that is, the number of men/women who are available for work.
    
  - [`lineplot_AggregateUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/lineplot_AggregateUnempRate.png)
    : aggregate unemployment rate of countries in Europe, European Union 15, European Union 21, G7, OECD, respectively
  - [`stripplot_JuniorUnempRate_jitter.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/stripplot_JuniorUnempRate_jitter.png)
    : jittered stripplot of junior level unemployment rate (agewise unemployment rate for the age group 15-24)
      of countries.
  - [`stripplot_JuniorUnempRate_violin.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/stripplot_JuniorUnempRate_violin.png)
    : violin plot of junior level unemployment rate (agewise unemployment rate for the age group 15-24)
      of countries.



## Details of the study: Step 1 - data cleaning and manipulation

This section explains what is done in [`01_filterReorder.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/01_filterReorder.R).





## Details of the study: Step 2 - creation of plots

This section explains what is done in [`02_aggregatePlot.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/02_aggregatePlot.R).













