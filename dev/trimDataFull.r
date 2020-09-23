library(tidyverse)


# Load full data set
# Note that this code is used locally to sprocess the full data
dataFull <- read.table("data/anes_timeseries_cdf_rawdata.txt", 
                        header=TRUE, sep=",", dec=".")

# Output only neccessary data
data1<- dataFull %>% select(  "VCF0004", # year
                                     "VCF0201", # 0201 - 0253: thermometer
                                     "VCF0202",
                                     "VCF0110",    #education 
                                     "VCF0206",
                                     "VCF0207",
                                     "VCF0211",
                                     "VCF0212",
                                     "VCF0217",
                                     "VCF0218",
                                     "VCF0219",
                                     "VCF0220",
                                     "VCF0221",
                                     "VCF0222",
                                     "VCF0223",
                                     "VCF0224",
                                     "VCF0225",
                                     "VCF0226",
                                     "VCF0227",
                                     "VCF0228",
                                     "VCF0229",
                                     "VCF0230",
                                     "VCF0231",
                                     "VCF0232",
                                     "VCF0233",
                                     "VCF0234",
                                     "VCF0235",
                                     "VCF0236",
                                     "VCF0253",
                                     "VCF0303", # political id
                                     "VCF0375b", # dem like
                                     "VCF0376b",
                                     "VCF0377b",
                                     "VCF0378b",
                                     "VCF0379b",
                                     "VCF0381b", # dem dislike
                                     "VCF0382b",
                                     "VCF0383b",
                                     "VCF0384b",
                                     "VCF0385b",
                                     "VCF0387b", # rep like
                                     "VCF0388b",
                                     "VCF0389b",
                                     "VCF0390b",
                                     "VCF0391b",
                                     "VCF0393b", # rep dislike
                                     "VCF0394b",
                                     "VCF0395b",
                                     "VCF0396b",
                                     "VCF0397b",
                                     "VCF0426", 
                                     "VCF9223"    #How likely immigrant steal job
                             )

# export to file
write.csv(data1, "output/anes_trimmed.csv", row.names = TRUE)



