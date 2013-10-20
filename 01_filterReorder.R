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
# Drop the too-detailed factor levels that applies to part of the countries:
#   - "15 to 19" and "20 to 24" in Age does not apply for some countries.
#     Those countries have the level "15 to 24" instead.
#     Of course, the countries that have "15 to 19" and "20 to 24"
#     still have the level "15 to 24".
#
Unemp.Dur = subset(Unemp.Dur, Sex != "All persons" &
                       Duration != "Total Declared" &
                       Age != "15 to 19" &
                       Age != "20 to 24" &
                       Age != "Total")
Unemp.Dur = droplevels(Unemp.Dur)

# The number of people cannot be analyzed without considering total labor force(Population).
# Labor force statistics contains information on population for each age, sex, country and year levels
Unemp.LFS = read.csv("Unemp_LaborForce.csv")

# Extract population data and clean data.
Unemp.LFS = subset(Unemp.LFS, Series == "Labour Force")
Unemp.LFS = subset(Unemp.LFS, select = -c(Series, Frequency, Flags))

# rename Value in Unemp.LFS as Population in preparation for merge function.
# rename function is in plyr package
Unemp.LFS = rename(Unemp.LFS, c("Value" = "LocalPop"))

# there is no "55+" level in Unemp.LFS while it is in Unemp.Dur. 
# Thus I need to create a new data for "55+"
# This can be done by plyr.
Unemp.LFS.55 = droplevels(subset(Unemp.LFS, Sex != "All persons" & Age %in% c("55 to 64", "65+")))
Unemp.LFS.55 = ddply(Unemp.LFS.55, ~ Sex + Country + Time, 
                     summarize, LocalPop = sum(LocalPop), Age = factor("55+"))

Unemp.LFS = rbind(Unemp.LFS, Unemp.LFS.55)

# attach the total population data to each row
# The information of Unemp.LFS.tot that does not fit into Unemp.LFS will be thrown away.
Unemp.LFS.tot = droplevels(subset(Unemp.LFS, Sex == "All persons" & Age == "Total"))
Unemp.LFS.tot = subset(Unemp.LFS.tot, select = -c(Sex,Age))
Unemp.LFS.tot = rename(Unemp.LFS.tot, c("LocalPop" = "TotalPop"))
Unemp.LFS = merge(Unemp.LFS, Unemp.LFS.tot, by=c("Country","Time"), all.x=TRUE)

# Attach information on Population to Unemp.Dur.
# The information of Unemp.LFS that does not fit into Unemp.Dur will be thrown away.
Unemp.Dur = merge(Unemp.Dur, Unemp.LFS, by=c("Sex","Age","Country","Time"), all.x=TRUE)


# There was no data on the population of the aggregate "North America" and "Oceania" level.
# I drop the "North America" and "Oceania" level here.
# Also, there are some missing data in Korea.
# I drop Korea here.
Unemp.Dur = droplevels(subset(Unemp.Dur, 
                              Country != "North America" & Country != "Oceania" & Country != "Korea"))

# rename "Time" to "Year"
# rename "Value" to "Unemployed"
# rename function is in plyr package
Unemp.Dur = rename(Unemp.Dur, c("Time" = "Year"))
Unemp.Dur = rename(Unemp.Dur, c("Value" = "Unemployed"))

# calculate proportion of the unemployed to the population.
Unemp.Dur = within(Unemp.Dur, UnempPropLocal <- Unemployed / LocalPop)
Unemp.Dur = within(Unemp.Dur, UnempPropTotal <- Unemployed / TotalPop)

# in Country variable, there are aggregatory levels, 
#   e.g. "Europe", "European Union 15", "G7 Countries", "OECD countries", etc.
# I put these aggregatory levels to the end by reordering the levels.
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

# Change some country names into a conventional short names.
# Also, change names of some aggregational levels to make the names consistent with others.
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



# make some descriptive plots.

# Unemployment rate in 2012 according to the countries

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

# plot age-wise Unemployment rate over the years for OECD countries

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

# remove auxiliary variables
rm(Unemp.Dur,
   Unemp.Dur.exhibit,
   Unemp.Dur.exhibit.age,
   Unemp.Dur.exhibit.re,
   Unemp.LFS,
   Unemp.LFS.55,
   Unemp.LFS.tot,
   Unemp.Custom.Levels)

