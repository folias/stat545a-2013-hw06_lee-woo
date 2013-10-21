##############################################
# Exploratory Data Analysis Procedure
##############################################

library(ggplot2)
library(plyr)
library(scales)


Unemp.Data <- read.csv("Unemp_Duration_Cleaned.csv")

## infer order of Country from order in file
Unemp.Data <- within(Unemp.Data,
                     Country <- factor(as.character(Country), levels = unique(Country))
                     )
## WARNING: probably not a safe long-run strategy for communicating factor level
## order with plain text data files; I see no guarantees that unique() return 
## value will be in any particular order; I have just noticed anecdotally that
## return value is in order of appearance



############################ genderwise area plots for selected countries

# function for drawing an areaplot for a country
plot.GenUnemp.byYear.Country = function(data, target.country) {
    table = subset(data, Country == target.country)
    table.sum = ddply(table, ~Sex+Country+Year+Duration, summarize, Unemployed = sum(Unemployed))
    table.tot = ddply(table, ~Sex+Country+Year, summarize, TotLocalPop = sum(LocalPop)/length(levels(Duration)))
    
    table.agg = merge(table.sum, table.tot, by=c("Sex","Country","Year"))
    table.agg = within(table.agg, UnempPropSLoc <- Unemployed/TotLocalPop)
    
    str.title = paste("Gender-wise unemployment rate,",target.country)
    
    plot.rect = data.frame(xmin = 2007.5, xmax = 2008.5, ymin = -Inf, ymax = Inf)
    
    ggplot(data=table.agg) + 
        geom_area(aes(x=Year, y=UnempPropSLoc, fill=Duration), position="stack") +
        geom_rect(data=plot.rect, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax), alpha=0.3, fill="grey20", inherit.aes = FALSE) +
        facet_grid(Sex~.) +
        xlab("Year (gray colored area denotes Subprime Financial Crisis)") +
        ylab("Gender-wise unemployment rate") +
        scale_x_continuous(breaks=seq(from=2000,to=2012,by=1)) +
        scale_y_continuous(labels = percent) +
        scale_fill_brewer(type = "seq", palette = "OrRd") +
        ggtitle(str.title)
    
    return(plot)
}

# function for drawing an areaplot for every country in the string vector "str.country"
plot.GenUnemp.byYear = function(data, str.country = levels(data$Country)) {
    for (string in str.country) {
        plot.country = plot.GenUnemp.byYear.Country(data=data, target.country=string)
        
        str.filename = paste("areaplot_GenderwiseUnempRate_",string,".png", sep="")
        plot.country
        ggsave(str.filename)
        dev.off()
    }    
}

# now, let's select some countries
str.interesting.countries = c(
    "Canada",
    "Denmark",
    "Estonia",
    "Germany",
    "Greece",
    "Ireland",
    "Spain",
    "Turkey",
    "United States"
    )

# finally, let's call the function to draw plots
plot.GenUnemp.byYear(Unemp.Data, str.country=str.interesting.countries)



############################ Lineplot for overall unemployment rate

# function for plotting line plots of overall unemployment rate
plot.AggUnemp.byYear = function(data) {
    aggData = ddply(data, ~Country+Year,
                    summarize,
                    Unemployed = sum(Unemployed),
                    TotalPop = mean(TotalPop))
    aggData = within(aggData, UnempRate <- Unemployed/TotalPop)
    plot.rect = data.frame(xmin = 2007.5, xmax = 2008.5, ymin = -Inf, ymax = Inf)
    
    ggplot(data=aggData) + 
        geom_line(aes(x=Year, y=UnempRate, color=Country), size=1.2) +
        geom_rect(data=plot.rect, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax), alpha=0.3, fill="grey20", inherit.aes = FALSE) +
        scale_x_continuous(breaks=seq(from=2000,to=2012,by=1)) +
        scale_y_continuous(labels = percent) +
        xlab("Year (gray colored area denotes Subprime Financial Crisis)") +
        ylab("Unemployment rate") +
        scale_color_brewer(type = "qual", palette = "Set2") +
        ggtitle("Aggregate Unemployment rates")
    ggsave("lineplot_AggregateUnempRate.png")
    dev.off()
}

# to draw lineplot, let's collect aggregation levels first
str.aggregations = c("European countries",
                     "EU 15 countries",
                     "EU 21 countries",
                     "G7 countries",
                     "OECD countries")

# subset the aggregatio levels from the original dataset
Unemp.Data.Aggregation = droplevels(subset(Unemp.Data, 
                                           Country %in% str.aggregations))

# finally, let's call the function to draw a lineplot
plot.AggUnemp.byYear(Unemp.Data.Aggregation)



############################ Stripplot and violin plot for junior level unemployment rate

# let's sort out junior level long-term unemployment rates and exclude aggregation levels before plotting
Unemp.Data.Junior = subset(Unemp.Data, Age == "15 to 24" & !(Country %in% str.aggregations) )
Unemp.Data.Junior = droplevels(subset(Unemp.Data.Junior, 
                                      Duration == "> 6 month and < 1 year" | Duration == "1 year and over"))
Unemp.Data.Junior = ddply(Unemp.Data.Junior, ~Age+Country+Year,
                          summarize,
                          Unemployed = sum(Unemployed),
                          LocalPop = sum(LocalPop)/length(levels(Duration)))
Unemp.Data.Junior = within(Unemp.Data.Junior, LocalUnemp <- Unemployed/LocalPop )

# now let's make the last two plots!
str.title = "Ratio of long-term (> 6 months) unemployed people at age 15-24 \n to Labor Force (People available for work) at that age"

# set rectangle
plot.rect = data.frame(xmin = 2007.5, xmax = 2008.5, ymin = -Inf, ymax = Inf)

# choose countries to annotate
Unemp.Data.Junior.Subset = subset(Unemp.Data.Junior, LocalUnemp >= 0.165)

ggplot(data=Unemp.Data.Junior) +
    geom_point(aes(x=Year, y=LocalUnemp), position = position_jitter(width=0.1,height=0)) +
    geom_text(data=Unemp.Data.Junior.Subset, aes(x=Year, y=LocalUnemp, label=Unemp.Data.Junior.Subset$Country), size=4, angle=20, hjust=1.1, vjust=0) +
    geom_rect(data=plot.rect, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax), alpha=0.3, fill="grey20", inherit.aes = FALSE) +
    scale_x_continuous(breaks=seq(from=2000,to=2012,by=1)) +
    scale_y_continuous(labels = percent) +
    xlab("Year (gray colored area denotes Subprime Financial Crisis)") +
    ylab("Age-wise unemployment rate") +
    ggtitle(str.title)
ggsave("stripplot_JuniorUnempRate_jitter.png")
dev.off()

ggplot(data=Unemp.Data.Junior) +
    geom_violin(aes(x=factor(Year), y=LocalUnemp, fill=factor(Unemp.Data.Junior$Year == 2008))) +
    scale_y_continuous(labels = percent) +
    scale_fill_brewer(type = "seq", palette = "Greys") +
    xlab("Year (gray colored one denotes the year of Subprime Financial Crisis)") +
    ylab("Age-wise unemployment rate") + 
    theme(legend.position = "none") +
    ggtitle(str.title)
ggsave("stripplot_JuniorUnempRate_violin.png")
dev.off()


# remove objects
rm(Unemp.Data,
   Unemp.Data.Aggregation,
   Unemp.Data.Junior,
   Unemp.Data.Junior.Subset,
   str.aggregations,
   str.interesting.countries,
   str.title,
   plot.rect,
   plot.AggUnemp.byYear,
   plot.GenUnemp.byYear,
   plot.GenUnemp.byYear.Country)





