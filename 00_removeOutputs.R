## clean out any previous work

string.outputs <- c("barchart_2012_AggregateUnempRate.png", # 01_filterReorder.R
                    "barchart_2012_AgewiseUnempRate.png",   # 01_filterReorder.R
                    "Unemp_Duration_Cleaned.csv",           # 01_filterReorder.R
                    "lineplot_AggregateUnempRate.png",      # 02_aggregatePlot.R
                    "stripplot_JuniorUnempRate_jitter.png", # 02_aggregatePlot.R
                    "stripplot_JuniorUnempRate_violin.png"  # 02_aggregatePlot.R
)

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

for (string in str.interesting.countries) {
    string.areaplot.files = paste("areaplot_GenderwiseUnempRate_",string,".png", sep="")
    string.outputs = c(string.outputs, string.areaplot.files)
}
    


file.remove(string.outputs)

# remove string.outputs
rm(string.outputs,
   str.interesting.countries,
   string,
   string.areaplot.files)

