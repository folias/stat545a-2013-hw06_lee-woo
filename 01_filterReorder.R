##############################################
# Data Import and Data Preparation Procedure
##############################################
# 
# Data Source:
# OECD (2010), "Labour Market Statistics: Labour force statistics by sex and age", 
#   OECD Employment and Labour Market Statistics (database).
# OECD (2010), "Labour Market Statistics: Unemployment by duration", 
#   OECD Employment and Labour Market Statistics (database).
# 
# http://dx.doi.org/10.1787/data-00309-en
# http://dx.doi.org/10.1787/data-00320-en
# 
# Data manipulation can be done via OECD database tool, 
# but all options are set as default for the data cleaning exercise.

library(ggplot2)
library(plyr)
library(scales)

# import dataset. Unemployment by duration is the main target of the analysis.
Unemp.Dur = read.csv("Unemp_Duration.csv")

# drop the unused variables :
# 1. "Flags" is not used
# 2. "Frequency" is all annual.
Unemp.Dur = subset(Unemp.Dur, select = -c(Flags,Frequency))

# Drop the levels that are aggregations of other levels:
#   - "All persons" in Sex
#   - "Total" in Age
#   - "Total Declared" in Duration
# Drop the too-detailed factor levels that applies to some of the countries only:
#   - "15 to 19" and "20 to 24" in Age does not apply for some countries.
#     Those countries have the level "15 to 24" instead.
#     Of course, the countries that have "15 to 19" and "20 to 24" still have the level "15 to 24".
#     Hence, I just drop these two levels.
Unemp.Dur = subset(Unemp.Dur, Sex != "All persons" &
                       Duration != "Total Declared" &
                       Age != "15 to 19" &
                       Age != "20 to 24" &
                       Age != "Total")
Unemp.Dur = droplevels(Unemp.Dur)

# The number of unemployed people cannot be compared across countries and
#   across different categories within a country
#   without considering labor force of each category.
# In other words, we should use the number of the unemployed relative to the labor force
#   instead of just using the number of the unemployed when making a comparison.
# Labor force statistics contains information on labor force
#   for each age, sex, country and year levels, and that's why I need Labour Force statistics data.
Unemp.LFS = read.csv("Unemp_LaborForce.csv")

# Extract the labor force data from the raw data and perform a quick clean of the data.
# I drop Frequency and Flags as I did for Unemp.Dur
# I drop Series since I subsetted the data so that Series has only one level: "Labour Force".
Unemp.LFS = subset(Unemp.LFS, Series == "Labour Force")
Unemp.LFS = subset(Unemp.LFS, select = -c(Series, Frequency, Flags))

# rename Value in Unemp.LFS as Population in preparation for the use of merge function.
# rename function is in plyr package
Unemp.LFS = rename(Unemp.LFS, c("Value" = "LocalPop"))

# there is no "55+" level in Unemp.LFS while it is in Unemp.Dur. 
# Thus I need to create a new data for "55+".
# Unemp.LFS has levels of "55 to 64" and "65+", so I should add the two
#  for each combination of categorical variables.
# This can be done by ddply in plyr.
Unemp.LFS.55 = droplevels(subset(Unemp.LFS, Sex != "All persons" & Age %in% c("55 to 64", "65+")))
Unemp.LFS.55 = ddply(Unemp.LFS.55, ~ Sex + Country + Time, 
                     summarize, LocalPop = sum(LocalPop), Age = factor("55+"))
# attach factor level "55+" to the original labor force dataset.
Unemp.LFS = rbind(Unemp.LFS, Unemp.LFS.55)

# Now Unemp.LFS has data on labor force for each combination of categorical variables.
# This is used for calculaing the "local" unemployment rate for each category,
#   and I need the data on total labor force for each country and each year
#   to calculate overall unemployment rate for each country and for each year.
# The code below attaches the total population data for each country and for each year 
#   to each row of Unemp.LFS
Unemp.LFS.tot = droplevels(subset(Unemp.LFS, Sex == "All persons" & Age == "Total"))
Unemp.LFS.tot = subset(Unemp.LFS.tot, select = -c(Sex,Age))
Unemp.LFS.tot = rename(Unemp.LFS.tot, c("LocalPop" = "TotalPop"))
Unemp.LFS = merge(Unemp.LFS, Unemp.LFS.tot, by=c("Country","Time"), all.x=TRUE)

# Now we attach information on the labor force to Unemployment by Duration data.
# The information of Unemp.LFS that does not fit into Unemp.Dur will be automatically thrown away.
Unemp.Dur = merge(Unemp.Dur, Unemp.LFS, by=c("Sex","Age","Country","Time"), all.x=TRUE)


# There was no data on the population of the aggregate "North America" and "Oceania" level on Unemp.LFS.
# I drop the "North America" and "Oceania" level here.
# Also, there were some missing values in Korea.
# I drop Korea here.
Unemp.Dur = droplevels(subset(Unemp.Dur, 
                              Country != "North America" & Country != "Oceania" & Country != "Korea"))

# Now I rename the variables for easier interpretation.
#   rename "Time" to "Year"
#   rename "Value" to "Unemployed"
# rename function is in plyr package
Unemp.Dur = rename(Unemp.Dur, c("Time" = "Year"))
Unemp.Dur = rename(Unemp.Dur, c("Value" = "Unemployed"))

# Now I calculate proportion of the unemployed to the population, 
#   that is, "local" and overall unemployment rate.
Unemp.Dur = within(Unemp.Dur, UnempPropLocal <- Unemployed / LocalPop)
Unemp.Dur = within(Unemp.Dur, UnempPropTotal <- Unemployed / TotalPop)

# in Country variable, there are aggregatory levels, 
#   e.g. "Europe", "European Union 15", "G7 Countries", "OECD countries", etc.
# I reorder the levels so that these aggregatory levels go to the end.
Unemp.Custom.Levels = c(
    "Australia", "Austria", "Belgium", "Canada", "Czech Republic",
    "Denmark", "Estonia", "Finland", "France", "Germany",
    "Greece", "Hungary", "Iceland", "Ireland", "Israel", 
    "Italy", "Japan", "Korea", "Luxembourg", "Mexico",
    "Netherlands", "New Zealand", "Norway", "Poland", "Portugal",
    "Russian Federation", "Slovak Republic", "Slovenia", "Spain", "Sweden",
    "Turkey", "United Kingdom", "United States", "Europe", "European Union 15",
    "European Union 21", "G7 countries", "OECD countries")
Unemp.Dur = within(Unemp.Dur, Country <- factor(Country, levels = factor(Unemp.Custom.Levels)))

# I change some country names into a conventional short names.
# Also, I change names of some aggregational levels to make the names consistent with others.
# mapvalues function is in plyr package
Unemp.Dur = within(Unemp.Dur, Country <- mapvalues(Country, 
                                                   from=c("Russian Federation", "Slovak Republic",
                                                          "Europe",
                                                          "European Union 15", "European Union 21"),
                                                   to=c("Russia", "Slovakia",
                                                        "European countries",
                                                        "EU 15 countries", "EU 21 countries")))

# Finally, I sort the data according to the new country ordering
Unemp.Dur = arrange(Unemp.Dur, Country, Year, Sex, Age, Duration)



# Finally, I make some descriptive plots.

######################## Unemployment rate in 2012 according to the countries

# first, subset the data and reverse the factor level order to show the countries alphabetically in the y axis
Unemp.Dur.exhibit = subset(Unemp.Dur, Year == "2011")
Unemp.Dur.exhibit.re = within(Unemp.Dur.exhibit, Country <- factor(Country, levels = factor(rev(levels(Country)))))

# plot Unemployment rate
ggplot(data = Unemp.Dur.exhibit.re) + 
    geom_bar(aes(Country, fill=Duration, weight=UnempPropTotal)) +
    ylab("Unemployment rate") +
    ggtitle("Unemployment rates of countries, year 2012") +
    scale_y_continuous(labels = percent) +
    coord_flip() +
    scale_fill_brewer(type = "seq", palette = "OrRd")
ggsave("barchart_2012_AggregateUnempRate.png")
dev.off()

######################## age-wise Unemployment rate over the years for OECD countries

# first, summarize the data and reverse the factor level order to show the countries alphabetically in the y axis
Unemp.Dur.exhibit.age = ddply(Unemp.Dur.exhibit, ~ Age+Country+Year+Duration,
                              summarize, UnempPropLocal = sum(UnempPropLocal))
Unemp.Dur.exhibit.age = within(Unemp.Dur.exhibit.age,
                               Country <- factor(Country, levels = factor(rev(levels(Country)))))

# plot Unemployment rate for low unemployment rate countries
ggplot(data = Unemp.Dur.exhibit.age) + 
    geom_bar(aes(Country, weight=UnempPropLocal, fill=Duration)) +
    facet_grid(~Age) +
    ylab("Age-wise unemployment rate") +
    ggtitle("Age-wise unemployment rates of countries in 2012") +
    coord_flip() +
    scale_y_continuous(labels = percent) +
    scale_fill_brewer(type = "seq", palette = "OrRd")
ggsave("barchart_2012_AgewiseUnempRate.png")
dev.off()

# write the data to file
write.csv(Unemp.Dur, "Unemp_Duration_Cleaned.csv", row.names = FALSE)

# remove objects
rm(Unemp.Dur,
   Unemp.Dur.exhibit,
   Unemp.Dur.exhibit.age,
   Unemp.Dur.exhibit.re,
   Unemp.LFS,
   Unemp.LFS.55,
   Unemp.LFS.tot,
   Unemp.Custom.Levels)

