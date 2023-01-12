## ---------------------------
##
## Script Name: Create Endpoint Data for DNT60 data
##
## Purpose of Script: Format Padilla DNT60 data as mc0 prior to tcplfit2 analysis.
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
library(magrittr)
library(here)
library(gabi)

here::i_am("R/endpoint creation.R")


# Create endpoint data --------------------------------------------------

load(here("raw data","Padilla_DNT60_lmr0.Rdata"))

## format as mc0 and transform to mc0_n with Box-Cox
ac <- c("AUC_L","avgS_L", "hbt1_L", "hbt2_L","RoA_L",
        "strtlA","strtlAavg", "strtlF",
        "AUC_D", "avgS_D","hbt1_D", "hbt2_D", "RoA_D",
        "AUC_T","avgS_T","AUC_r")
mc0 <- lapply(ac, function(endp) as.data.table(gabi::as_mc0(lmr0, rval = endp, no.A = 10, no.L = 20, no.D = 20)))
names(mc0) <- ac
mc0_n <- lapply(mc0, gabi::apply_bxcx)

# save mc0 and mc0_n
save(mc0, file = here("pipelined data","Padilla_DNT60_mc0.rda"))
save(mc0_n, file = "pipelined data/Padilla_DNT60_mc0_n.rda")

rm(list = ls())
