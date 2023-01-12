## ---------------------------
##
## Script Name: DNT60 tcplfitter
##
## Purpose of Script: Fit tcplfit2 to DNT60 endpoint data.
##
## Author: Zachary Rowson
##
## Date Created: 2022-03-01
##
## Email: Rowson.Zachary@epa.gov
##
## Working Directory: "/ccte/home2/zrowson/Desktop/Stephanie Projects/DNT60 Analysis/pipelining"
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


here::i_am("R/tcplfitter.R")


# Run tcplfit2 --------------------------------------------------


# Load row data
load(here("pipelined data","Padilla_DNT60_rows_n.rda"))

# Get tcplfits
tcplfits_n <- lapply(rows_n, function (chm) {
  lapply(chm, function(row) {
    gabi::concRespCoreZR(row, do.plot = TRUE)})})


# Save fits
save(tcplfits_n, file = "pipelined data/Padilla_DNT60_tcplfits.rda")
