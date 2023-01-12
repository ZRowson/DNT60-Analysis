#-----------------------------------
# Gather Example Graphics for Paper
#   Zachary Rowson
#   Rowson.Zachary@epa.gov
# Created: 11/10/2021
# Last Edit : 11/10/2021
#-----------------------------------

library(gabi)
library(tcplfit2)
library(ggplot2)

# choose a chemical
i <- sample(1:length(chms), 1)
chemical <- chms[i]

# plot time series in SS and PA format
t.series_SS <- gabi::plot_tSeries(pmr0, chemical = chemical, prsp = "SS")
t.series_PA <- gabi::plot_tSeries(pmr0, chemical = chemical, prsp = "PA")

# plot endpoint boxplot for a randomly selected endpoint
j <- sample(1:16, 1)
e.dist <- gabi::plot_eDist(mc0_n[[j]][[1]], chemical = chemical)

# plot concentration-response for that chemical-endpoint pair
row <- rows_n[[j]][[i]]
fit <- gabi::concRespCoreZR(row, do.plot = TRUE)
conc.resp <- fit[["plot"]]


