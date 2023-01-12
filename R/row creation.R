## ---------------------------
##
## Script Name: Create DNT60 row Objects
##
## Purpose of Script: Create row objects from Padilla DNT60 mc0 data prior to tcplfit2
##                    curve-fitting.
##
## Author: Zachary Rowson
##
## Date Created: 2022-03-01
##
## Email: Rowson.Zachary@epa.gov
##
## Working Directory: "/ccte/home2/zrowson/Desktop/Stephanie Projects/OP Analysis/pipelining"
##
## ---------------------------
##
## Notes:
##
##
## ---------------------------

library(data.table)
library(here)
library(gabi)

here::i_am("R/row creation.R")


# Create row Objects --------------------------------------------------


# load endpoint data
load(here("pipelined data","Padilla_DNT60_mc0_n.rda"))

# Create tcpl row objects

# Gather chemical names. Separate chemicals that have only one replicate or had a concentration group that was removed
chemicals <- mc0_n[[1]][["data"]][wllt=="t",unique(cpid)]
names(chemicals) <- chemicals

# Create rows for chemicals
rows_n <- lapply(chemicals, function(chm) {
  # Create row objects for each endpoint
  lapply(mc0_n, function(list) {
    data <- list[["data"]]
    lam.hat <- list[["lam.hat"]]
    shift <- list[["shift"]]
    endp <- gsub("_ZFlmrALD-20-40-40","",data[,unique(acid)])
    gabi::as_row(data, endp=endp, chemical=chm, lam.hat=lam.hat, shift=shift)
  })
})

# Save row objects
save(rows_n, file = "pipelined data/Padilla_DNT60_rows_n.rda")


rm(list = ls())
