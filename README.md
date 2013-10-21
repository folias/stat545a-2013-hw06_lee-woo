stat545a-2013-hw06_lee-woo
==========================

stat545a homework 6 submitted by Wooyong Lee (83588129).

**Contents:**
- [Description of the raw data](https://github.com/folias/stat545a-2013-hw06_lee-woo#description-of-the-raw-data)
- [Objective of the study and the work flow](https://github.com/folias/stat545a-2013-hw06_lee-woo#objective-of-the-study-and-the-work-flow)
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
  - **Sex**: gender group (male, female, all persons)
  - **Age**: standardized age groups (15-19, 15-24, 20-24, 25-54, 55+, total)
  - **Frequency**: Frequency of observations (Monthly, Quarterly, Annual, etc. For the datasets I use, only annual data is available)
  - **Country**: countries (OECD member countries + some aggregate data such as data for OECD countries, G7 countries,
    European countries, etc)
  - **Duration**: duration of unemployment.  ( < 1 month, > = 1 month and < 3 months, > = 3 months and < 6 months, > = 6 months and <1 year, 1 year and over, total declared)
  - **Time**: Time of the record (2000, 2001, ..., 2012)
  - **Value**: the number of unemployed people (numeric, unit: thousands of persons)

- [`Unemp_LaborForce.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_LaborForce.csv)
  - **Series**: type of the record (population, labor force, employment, unemployment)
  - **Sex**: gender group (male, female, all persons)
  - **Age**: standardized age groups (15-24, 25-54, 55-64, 65+, total)
  - **Frequency**: Frequency of observations (Monthly, Quarterly, Annual, etc. For the datasets I use, only annual data is available)
  - **Country**: countries (OECD member countries + some aggregate data such as data for OECD countries, G7 countries,
    European countries, etc)
  - **Time**: Time of the record (2000, 2001, ..., 2012)
  - **Value**: the number of people that fits into the value of Series (numeric, unit: thousands of persons)

  



## Objective of the study and the work flow

**Objective:** Take a look at the impact of Subprime Mortgage Financial Crisis in 2008 
([Wikipedia page for Subprime Financial Crisis](http://en.wikipedia.org/wiki/Subprime_mortgage_crisis))
on OECD countries in terms of the unemployment rate by visualizing the data.

**Overall work flow:**

1. perform data cleaning and data manipulation, and produce two descriptive plots and well-organized data for the next step.
2. provide more plots based on the data prepared in the first step.



## Details of the study: overview


**To replicate the study:** 
Copy all the inputs in a directory. Run 
[`Makefile.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Makefile.R)
via R console or Rstudio.


- Inputs: 
  - raw data files:
  [`Unemp_Duration.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration.csv)
  and
  [`Unemp_LaborForce.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_LaborForce.csv)
  - R code 1: A R code file that rules all the procedures: 
  [`Makefile.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Makefile.R)
  - R code 2: R code files required to run [`Makefile.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Makefile.R):
  [`00_removeOutputs.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/00_removeOutputs.R),
  [`01_filterReorder.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/01_filterReorder.R) and
  [`02_aggregatePlot.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/02_aggregatePlot.R)
- Outputs:
  - [`Unemp_Duration_Cleaned.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration_Cleaned.csv)
    : a cleaned and manipulated dataset
  - [`barchart_2012_AggregateUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/barchart_2012_AggregateUnempRate.png)
    : unemployement rate of countries in 2012.
  - [`barchart_2012_AgewiseUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/barchart_2012_AgewiseUnempRate.png)
    : age-wise unemployement rate of countries in 2012.
    By age-wise unemployment rate, I define it as the ratio of the number of unemployed people in a age group to
    labor force in that age group, that is, the number of people who are available for work in that age group.
  - `areaplot_GenderwiseUnempRate_COUNTRY.png`
    : an areaplot of gender-wise unemployment rate over the years for COUNTRY, gridded by gender, 
    where COUNTRY is one of: Canada, Denmark, Estonia, Germany, Greece, Ireland, Spain, Turkey and United States.
    By gender-wise unemployment rate, I define it as the ratio of the number of unemployed men/women to
    labor force of men/women, that is, the number of men/women who are available for work.
    
  - [`lineplot_AggregateUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/lineplot_AggregateUnempRate.png)
    : aggregate unemployment rate of countries in Europe, of European Union 15, of European Union 21, in G7 and in OECD over the years.
  - [`stripplot_JuniorUnempRate_jitter.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/stripplot_JuniorUnempRate_jitter.png)
    : jittered stripplot of long-term( > 6 month ) junior level unemployment rate (agewise unemployment rate for the age group 15-24)
      of countries over the years.
  - [`stripplot_JuniorUnempRate_violin.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/stripplot_JuniorUnempRate_violin.png)
    : violin plot of long-term( > 6 month ) junior level unemployment rate (agewise unemployment rate for the age group 15-24)
      of countries over the years.





## Details of the study: Step 1 - data cleaning and manipulation

[`01_filterReorder.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/01_filterReorder.R)
performs Step 1.

- The inputs of Step 1:
  - [`Unemp_Duration.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration.csv)
  - [`Unemp_LaborForce.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_LaborForce.csv)
- The outputs of Step 1:
  - [`Unemp_Duration_Cleaned.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration_Cleaned.csv)
  - [`barchart_2012_AggregateUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/barchart_2012_AggregateUnempRate.png)
  - [`barchart_2012_AgewiseUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/barchart_2012_AgewiseUnempRate.png)


For the procedure to produce [`Unemp_Duration_Cleaned.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration_Cleaned.csv),
many things are done, I put the step-by-step explanations in the R code since I believe that
this would be easier for the code reader to understand what is going on
than writing all the things here and giving the code.
See the comments in
[`01_filterReorder.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/01_filterReorder.R).

A brief explanation and some observations for the figures are as follows.

- [`barchart_2012_AggregateUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/barchart_2012_AggregateUnempRate.png)
  
  This is a descriptive plot for the dataset. This shows unemployment rate in 2012 for OECD countries.
  The two highest unemployment rates are those of Greece and Spain, reflecting the fact that
  they have been suffering from financial crisis recently.

  Also, Ireland, Portugal and Slovakia show high unemployment rates. Especially for Ireland, it will be shown that
  the unemployment rate of Ireland increased dramatically after Subprime crisis in Step 2.
  
  Note that short-term unemployment is sometimes not considered as an issue
  since it can be interpreted as a job-seeking period until one finds a job.
  On the other hand, high long-term unemployment rate is a serious problem for a country.
  In this perspective, Mexico is better than Japan when it comes to unemployment problem
  even though unemployment rate for Mexico is a little larger than that of Japan.

- [`barchart_2012_AgewiseUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/barchart_2012_AgewiseUnempRate.png)

  This is another descriptive plot for the dataset. This is a age-wise unemployment rate in 2012 for OECD countries.
  We can see that the labor markets of Greece and Spain are extremely bad considering that
  about 25% of people in the age of 15-24 are seeking for job for more than one year.


## Details of the study: Step 2 - creation of plots

[`02_aggregatePlot.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/02_aggregatePlot.R)
performs Step 2.
- The input of Step 1:
  - [`Unemp_Duration_Cleaned.csv`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/Unemp_Duration_Cleaned.csv)
- The outputs of Step 1:
  - `areaplot_GenderwiseUnempRate_COUNTRY.png`
    where COUNTRY is one of: Canada, Denmark, Estonia, Germany, Greece, Ireland, Spain, Turkey and United States.
    
  - [`lineplot_AggregateUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/lineplot_AggregateUnempRate.png)
  - [`stripplot_JuniorUnempRate_jitter.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/stripplot_JuniorUnempRate_jitter.png)
  - [`stripplot_JuniorUnempRate_violin.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/stripplot_JuniorUnempRate_violin.png)


The code for Step 2,
[`02_aggregatePlot.R`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/02_aggregatePlot.R),
is quite straightforward and consists of three parts:

1. Genderwise area plot for selected countries
2. Lineplot for overall unemployment rate of European countries, 
   EU 15 countries, EU 21 countries, G7 countries and OECD countries.
3. Stripplot and violin plot for long-term( > 6 month ) junior level unemployment rate (age group 15-24)
   of countries in the dataset.


A brief explanation and some observations for the figures are as follows.

  - `areaplot_GenderwiseUnempRate_COUNTRY.png`
    where COUNTRY is one of: Canada, Denmark, Estonia, Germany, Greece, Ireland, Spain, Turkey and United States.

     these area plots for selected countries have some interesting features.
     
     - Canada's unemployment rate is almost not affected by Subprime shock; only its short-term unemployment increased temporarily.
     - Estonia, Turkey and United States are gradually escaping from Subprime shock recently in terms of unemployment rate.
     - Denmark is still not escaping from Subprime shock, but its unemployment rate stopped increasing in 2012.
     - Germany's unemployment rate has been decreasing for years even with Subprime shock.
     - In Greece, Ireland and Spain, the labor markets went
       really bad after Subprime shock. Especially, long-term unemployment rate for men is greatly increased in Ireland
       since Subprime shock.

  - [`lineplot_AggregateUnempRate.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/lineplot_AggregateUnempRate.png)
    
    From the plot, we can get the idea of how the world's unemployment rate has been changed since Subprime shock.
    According to the plot, G7 and OECD countries are escaping from temporary Subprime shock overall.
    However, for European countries, Subprime shock seems to have a persistent effect on the unemployment rate.
    Also, considering that "EU 15 countries" and "EU 21 countries" have similar trajectories to European countries,
    it may be the case that Subprime shock had a negative effect on the labor markets of
    not only small European countries but also major EU member countries. 

  - [`stripplot_JuniorUnempRate_jitter.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/stripplot_JuniorUnempRate_jitter.png)
    and
    [`stripplot_JuniorUnempRate_violin.png`](https://github.com/folias/stat545a-2013-hw06_lee-woo/blob/master/stripplot_JuniorUnempRate_violin.png)

    From the plot, we can see how long-term ( > 6 month ) unemployment rate of junior level age group (age 15-24)
    has been changed over the years. I tried two kinds of plots - jittered strippplot and violin plot.
    
    From the violin plot, we can see that the "center of gravity" lies around 3% throughout the years while the upper-tail
    of the violin changes over the years. The tail had been shortened from 2003 to 2008, but then it has been stretching
    again since 2008.
    
    From the stripplot, we can see that which country suffers from the high long-term unemployment rate.
    I annotated the country if the long-term junior level unemployment rate is larger than or equal to 16.5%.
    We can see that Poland was one of the countries with highest long-term junior level unemployment rates until 2007
    while it does not appear after 2007.
    Also, we can see that Greece, Italy and Slovakia show high rates throught the years.
    Finally, Spain did not have high rate until 2009, but then it records the second-highest rate in 2012,
    reflecting its recent financial crisis.






