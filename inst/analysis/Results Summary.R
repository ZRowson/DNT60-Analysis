#-----------------------
# Results Summary
# Zachary Rowson
# Rowson.Zachary@epa.gov
# Created: 10/05/2021
# Last Edit: 10/26/2021
#-----------------------

library(data.table)
library(tidyverse)
library(magrittr)
library(gtools)
library(gridExtra)
library(grid)

# Upload data with "Upload Data.R" and produce results with "tcplfitter2.R"

#############################################
#############################################
##
## 1. Look at results by endpoint
##    a) count number of active calls
##       by endpoint
##    b) group chemicals by which endpoint
##       they are found active in
##
## 2. Look at results by experimental period
##    a) create activity profiles for chems
##       describing periods where they are
##       active
##    b) group chemicals by activity
##       "profile"
##    c) count number of active calls per
##       period
##
## 3. Look at results by chemical
##    a) for each chemical list their endpoint
##       activity profile
##    b) count number of active calls per
##       chemical
##    c) group chemicals that share
##       endpoint-activity profiles
##
## 4. Obtain BMD ranges
##    a) for all chemicals
##    b) for only chemicals active in at least
##       one endpoint
##    c) plot heat maps of bmd by chem-acid
##    d) plot range of bmd values by acid as
##       violin plots
##
## 5. Compare maximum deviation to hitcalls
##    a) count number of chemicals with at least one devaition over 3 sds
##
###############################################
###############################################



##########################
# 1. Results by Endpoint #
##########################

# 1a) count  number of hits per endpoint

## assay components/endpoints
ac <- c("AUC_L", "AUC_D", "AUC_T", "AUC_r", "avgS_L", "avgS_D",
        "avgS_T", "avgA_L", "avgA_D", "avgJ_L", "avgJ_D", "frzA",
        "frzF","strtlA","strtlAavg", "strtlF", "hbt_L", "hbt_D")

## elongate hits data
hits.dt <- as.data.table(hits, keep.rownames = TRUE)
hits.dt[, cpid := rn][, rn := NULL]
hits_long <- melt(hits.dt, id.vars = "cpid", measure.vars = names(hits)[1:18],
                  variable.name = "acid", value.name = "hitcall")

## count number of hits per endpoint
hitcnt.ac <- hits_long[, .N, by = acid]
hits.temp <- hits_long[hitcall > 0.8, .N, by = acid]
temp <- hits.temp[hitcnt.ac, on = "acid"][, i.N := NULL]
rm(hits.temp, hitcnt.ac); hitcnt.ac <- temp; rm(temp)
hitcnt.ac[is.na(N), N := 0]

# 1b) find chemicals active in a each endpoint

## lapply looping through endpoints by name finding hits
names(ac) <- ac
e.grps <- lapply(ac, function(endp) {
              hits_long[acid==endp & hitcall>0.8, cpid]
            })

#####################################
# 2. Results by Experimental Period #
#####################################

# 2a) create table of activity-in-period profiles for chemicals

## separate endpoints by the experimental period they represent
ac.F <- ac[12:13]
ac.L <- grep("L", ac, value = T) # light assay components
ac.S <- ac[14:16] # startle assay components
ac.D <- grep("D", ac, value = T) # dark assay components

# declare hit.p.prfls table
hit.p.prfls <- data.table(cpid = chms)

## iteratively update hit.p.prfls
lapply(chms, function(chm) {
              hitcalls <- hits[chm, ] # extract hitcalls for chm as a vector

              # include dichotomous indicator of activity
              if (any(hitcalls[ac.F] > 0.8)) {
                hit.p.prfls[cpid == chm, Freeze := 1]
              } else {hit.p.prfls[cpid == chm, Freeze := 0]}
              if (any(hitcalls[ac.L] > 0.8)) {
                hit.p.prfls[cpid == chm, Light := 1]
              } else {hit.p.prfls[cpid == chm, Light := 0]}
              if (any(hitcalls[ac.S] > 0.8)) {
                hit.p.prfls[cpid == chm, Startle := 1]
              } else {hit.p.prfls[cpid == chm, Startle := 0]}
              if (any(hitcalls[ac.D] > 0.8)) {
                hit.p.prfls[cpid == chm, Dark := 1]
              } else {hit.p.prfls[cpid == chm, Dark := 0]}
})

## save as a data.frame for use later on
hit.p.prfls.df <- as.data.frame(hit.p.prfls[,.(Freeze,Light,Startle,Dark)]); rm(hit.p.prfls)
row.names(hit.p.prfls.df) <- chms

# 2b) group chemicals by activity profile

## find all possible activity profiles by permuting c(0,1) 4 entries long
prmu <- gtools::permutations(2,4, v = c(0,1), repeats.allowed = T)

## find which chemicals have a particular profile
prfl.p.grps <- apply(prmu, 1, function(y) {
                                match <- apply(hit.p.prfls.df, 1, function(row) {
                                                              x <- as.numeric(row)
                                                              identical(x, y)})
                                names(which(match == T))
              })
names(prfl.p.grps) <- apply(prmu, 1, paste0, collapse = "")
Filter(function(x) length(x) != 0, prfl.p.grps)

## 2c) count number of active calls per experimental period
hitcnt.p <- colSums(hit.p.prfls.df)

##########################
# 3. Results by Chemical #
##########################

# 3a) like for experimental periods, create activity profiles for endpoints

## declare hit.e.prfls table
hit.e.prfls <- data.table(cpid = rep(chms,each=18))
hit.e.prfls[, `:=` (acid = rep(ac,length(chms)), value = as.numeric(rep(NA,length(cpid))))]

## iteratively update hit.e.prfls
lapply(chms, function(chm) {
              # extract hitcalls for chm as a vector
              hitcalls <- hits[chm, ]

              # include dichotomous indicator of activity
              lapply(ac, function(e) {
                if (hitcalls[e] > 0.8) {
                  hit.e.prfls[cpid==chm & acid==e, value := 1]
                } else hit.e.prfls[cpid==chm & acid==e, value := 0]
              })
             })

## widen data for profile comparison
hit.ep.long <- data.table::dcast(hit.e.prfls, cpid ~ acid, value.var = "value")
hit.ep <- as.data.frame(copy(hit.ep.long)[, cpid := NULL])
names <- hit.ep.long[, cpid]
rownames(hit.ep) <- names

# 3b) count number of active endpoints per chemical
hitcnt.chms <- rowSums(hit.ep)
rev(hitcnt.chms[order(hitcnt.chms)])

# 3c) find which chemicals have a particular profile

## find each chemicals endpoint profile
ep <- apply(hit.ep, 1, paste0, collapse = "")
hit.e.grps <- lapply(ep, function(x) names[which(ep==x)]) %>% unique()
grps <- Filter(function(x) length(x) > 1, hit.e.grps)
names <- as.character(lapply(grps, function(x) {
                                    chm <- x[1]
                                    ep[chm]}))
names(grps) <- names
grps

#############################
# 4. Isolate Potency Ranges #
#############################

## obtain hitcalls and potency ranges for all chemicals at all endpoints
n <- length(ac)
cpid <- rep(chms, each=n)
bmd.rng <- data.table(cpid = cpid, acid = rep(ac, length(chms)))
lapply(tcplfits_n, function(chm) {
  lapply(chm, function(ac) {
    summ <- ac$summary
    assay <- gsub("_ZFpmrALD-20-40-40", "", summ$assay)
    bmd.rng[cpid==summ$name & acid==assay, `:=` (hitcall=summ$hitcall, BMDL=summ$bmdl,
                                                 BMD=summ$bmd, BMDU=summ$bmdu)]
    })
})

## obtain hitcalls and potency ranges for hits
bmd.rng.hits <- bmd.rng[hitcall > 0.8]

##################
# Venn Diagrams #
#################

library(VennDiagram)
library(grid)
library(gridExtra)

# use habituation endpoints as a practice round

## look at overlap of hits in hbt_L and hbt_D
sets <- VennDiagram::calculate.overlap(e.grps[c("hbt_L", "hbt_D")])

## calculate set sizes
set.size <- lapply(sets, length)

## create venn diagrams / Euler graphics
venn <- draw.pairwise.venn(set.size[[1]], set.size[[2]], set.size[[3]],
                   category = c("hbt_L", "hbt_D"),
                   euler.d = TRUE, scaled = TRUE,
                   cat.cex = rep(1.5,2),
                   fill = viridis::viridis(2),
                   alpha = rep(0.5,2),
                   ind = FALSE)
# venn.grob <- gTree(children = venn)
grid.arrange(gTree(children = venn),
             top = textGrob("Habituation in Light and Dark Overlap", gp=gpar(fontsize=24)))
rm(sets, set.size, venn)


# look at overlap of endpoint activity in Light and Dark exclude AUC and avgJ

## look at overlap of hits in Light
sets <- VennDiagram::calculate.overlap(e.grps[c("avgS_L","avgA_L","hbt_L")])
venn <- VennDiagram::venn.diagram(e.grps[c("avgS_L","avgA_L","hbt_L")],
                          filename = NULL,
                          main = "Light Endpoints Overlap", main.cex = 2,
                          fill = viridis::viridis(3),
                          euler.d = TRUE, scaled = TRUE)
grid.arrange(gTree(children = venn))
## calculate set sizes
set.size <- lapply(sets, length)

## look at overlap of hits in Dark
sets <- VennDiagram::calculate.overlap(e.grps[c("avgS_D","avgA_D","hbt_D")])
venn <- VennDiagram::venn.diagram(e.grps[c("avgS_D","avgA_D","hbt_D")],
                                  filename = NULL,
                                  main = "Dark Endpoints Overlap", main.cex = 2,
                                  fill = viridis::viridis(3),
                                  euler.d = TRUE, scaled = TRUE)
grid.arrange(gTree(children = venn))

## look at overlap of Transitory hits
sets <- VennDiagram::calculate.overlap(e.grps[c("strtlA","strtlAavg","strtlF")])
venn <- VennDiagram::venn.diagram(e.grps[c("strtlA","strtlAavg","strtlF")],
                                  filename = NULL,
                                  main = "Transitory Endpoints Overlap", main.cex = 2,
                                  fill = viridis::viridis(3),
                                  euler.d = TRUE, scaled = TRUE)
grid.arrange(gTree(children = venn))

## look at overlap of avgS_L and strtlAavg hits
sets <- VennDiagram::calculate.overlap(e.grps[c("strtlAavg","avgS_L")])
venn <- VennDiagram::venn.diagram(e.grps[c("strtlAavg","avgS_L")],
                                  filename = NULL,
                                  main = "avgS_L and srtlAavg Overlap", main.cex = 2,
                                  fill = viridis::viridis(2),
                                  euler.d = TRUE, scaled = TRUE)
grid.arrange(gTree(children = venn))

## look at overlap of Light, Dark, and Transitory activity
lapply(c("Light","Transitory","Dark"), function(prd) hit.p.prfls[])
p.grps <- list(Light = hit.p.prfls[Light==1, cpid],
               Dark = hit.p.prfls[Dark==1, cpid],
               Transition = hit.p.prfls[Startle==1, cpid])

sets <- VennDiagram::calculate.overlap(p.grps)
venn <- VennDiagram::venn.diagram(p.grps,
                                  filename = NULL,
                                  main = "Activity by Period Overlap", main.cex = 2,
                                  fill = viridis::viridis(3),
                                  euler.d = TRUE, scaled = TRUE)
grid.arrange(gTree(children = venn))


###########################################
## Compare Maximum Deviation to hitcalls ##
###########################################

greater <- function(x, value) {
  bool <- abs(x) >= value
  return(bool)
}

# number of chemicals with at least one endpoint with a large test group deviation from control response
apply(deviation.val, 2, greater, 3) %>%
  apply(., 1,  function(row) any(row==TRUE)) %>%
  which(. == TRUE) %>%
  length()

# create Venn Diagram of overlap of chemicals with one active hitcall and a "large" deviation
# later look at if hitcalls are dectecting large deviation. What % of active chem-endp pairs observed a deviation > 3

library(data.table)

## extract chemical-endpoint pairs with large deviation
dev.val.dt <- as.data.table(deviation.val, keep.rownames = "cpid")
dv.dt_long <- data.table::melt(dev.val.dt, id.vars = "cpid", variable.name = "endpoint", value.name = "deviation")
large.dev <- dv.dt_long[abs(deviation) > 3, paste0(cpid,endpoint)]

## extract chemical-endpoint pairs with active hitcalls
hit.dt_long <- as.data.table(do.call("rbind", hitcalls_n), keep.rownames = "cpid") %>%
  melt(., id.vars = "cpid", variable.name = "endpoint", value.name = "hitcall")
actv.call <- hit.dt_long[hitcall > 0.8, paste0(cpid,endpoint)]

x <- sapply(activecalls_n, length)
actv.call <- which(x != 0) %>%
                names()
venn <- VennDiagram::venn.diagram(list("Deviation more \n than 3 SE's"= large.dev,
                               "Active Hitcall"=actv.call),
                          filename=NULL, euler.d = TRUE, scaled = TRUE,
                          cat.cex = rep(1.5,2),
                          fill = viridis::viridis(2),
                          alpha = rep(0.5,2))
gridExtra::grid.arrange(gTree(children = venn),
             top = textGrob("Chemical-Endpoint Pairs with Active Hitcalls or Large Deviation", gp=gpar(fontsize=24)))
