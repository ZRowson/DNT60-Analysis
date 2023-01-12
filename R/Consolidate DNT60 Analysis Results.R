## ---------------------------
##
## Script Name: Consolidate DNT60 Anlayis Results
##
## Purpose of Script: Save a table full of summary data from tcplfit2 analysis and
##                    save graphs an .pngs in a graphics folder
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


# tcplfit2 output tables --------------------------------------------------


# Load developmental tcplfits
load(here("pipelined data","Padilla_DNT60_tcplfits.rda"))

# Create table of tcpl output data for developmental exposures
data <- lapply(tcplfits_n, function(chm) {
  x <- lapply(chm, function(endp) {
        summary <- endp[["summary"]]
        summary[,!names(summary)%in%c("conc","resp")]})
  do.call('rbind', x)
})

DNT60_tcpl_out <- do.call('rbind', data)

save(DNT60_tcpl_out, file = "results/Padilla_DNT60_tcpl_out.Rdata")


# Save graphics -----------------------------------------------------------


setwd("results/concResp graphics")

# loop through chemicals printing tcplfit2 plots
chms <- names(tcplfits_n)
lapply(chms, function (chm) {
  dir.create(chm)
  setwd(chm)
  to_fit <- tcplfits_n[[chm]]
  lapply(to_fit, function(row) {
    summary <- row[["summary"]]
    png(paste0(paste("concResp", summary$name, summary$assay, sep= "_"),
               ".png"),
        width = 720,
        height = 720)
    print(row[["plot"]])
    dev.off()
  })
  setwd("..")
})
