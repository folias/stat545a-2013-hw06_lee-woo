stat545a-2013-hw06_lee-woo
==========================

stat545a homework 6 submitted by Wooyong Lee.

**Contents:**
- [Description of the raw data](https://github.com/folias/stat545a-2013-hw06_lee-woo/edit/master/README.md#description-of-the-raw-data)

## Description of the raw data

There are two datasets used in this homework.

List of datasets and their sources:

- [`Unemp_Duration.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration.csv) : 
 OECD (2010), "Labour Market Statistics: Unemployment by duration", 
 *OECD Employment and Labour Market Statistics (database)*. 

 This dataset contains annual unemployment data for OECD member countries from 2000 to 2012.
 (I don't know why it contains data in 2011 and 2012, but there are data points.)
 For each country and for each year, the number of the unemployed people are recorded according to the duration of
 unemployment. The data are segmentalized according to sex and standardized age groups.
 [Link to the dataset webpage] (http://dx.doi.org/10.1787/data-00320-en)

- [`Unemp_LaborForce.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_LaborForce.csv) : 
 OECD (2010), "Labour Market Statistics: Labour force statistics by sex and age", 
 *OECD Employment and Labour Market Statistics (database)*. 

 This dataset contains annual labor force(the number of people who are available for work) data for 
 OECD member countries from 2000 to 2012.
 (I don't know why it contains data in 2011 and 2012, but there are data points.)
 For each country and for each year, population, labor force, the number of the employed and the umemployed people are recorded. 
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

  




