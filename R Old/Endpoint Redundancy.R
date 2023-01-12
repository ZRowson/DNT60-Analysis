#----------------------------------
# Evaluate Redundancy of Endpoints
# Zachary Rowson
# Rowson.Zachary@epa.gov
# Created: 10/08/2021
# Last Edit: 10/08/2021
#----------------------------------

library(data.table)
library(magrittr)
library(stats)

# evaluate covariance of endpoint data when looking across control groups

## extract endpoint data from mc0 tables
rvals <- as.data.table(lapply(mc0_n, function(table) {
                control <- table[[1]][wllt == "v"]
                acid <- unique(control[, acid])
                name <- gsub("_ZFpmrALD-20-40-40", "", acid)
                control[[name]] <- control$rval
                control[[name]]
}))

## find covariance table
corr.ac <- stats::cor(rvals, use = 'complete.obs')
