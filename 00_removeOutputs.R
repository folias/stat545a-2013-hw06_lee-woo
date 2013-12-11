## clean out any previous work

string.outputs <- c("Unemp_Duration_Cleaned.csv", list.files(pattern = "*.png"))

file.remove(string.outputs)

# remove string.outputs
rm(string.outputs)

