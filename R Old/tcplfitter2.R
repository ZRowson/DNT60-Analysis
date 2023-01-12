#------------------------
# tcplfit2 fitter
# Zachary Rowson
# Rowson.Zachary@epa.gov
# Last Edit: 12/10/2021
#------------------------

library(data.table)
library(magrittr)
library(tcplfit2)
library(pheatmap)
library(gabi)
library(viridis)

# Import behavioral data

## load from .../gabi/data
load("~/R/gabi/data/DNT60pmr0.rda")
pmr0 <- as.data.table(DNT60pmr0); rm(DNT60pmr0) # I need to add dependency on data.table or change package to have no dependency at all

## load test-chemical names. Remove vehicle chemicals
chms <- sort(unique(pmr0$cpid))[-c(32,63)]

## format as mc0 and tranform to mc0_n with Box-Cox
ac <- c("AUC_L","avgS_L", "avgA_L", "avgJ_L","hbt_L",
        "strtlA","strtlAavg", "strtlF",
        "AUC_D", "avgS_D","avgA_D", "avgJ_D", "hbt_D",
        "AUC_T","avgS_T","AUC_r")
mc0 <- lapply(ac, function(endp) as.data.table(gabi::as_mc0(pmr0, rval = endp)))
names(mc0) <- ac
mc0_n <- lapply(mc0, gabi::apply_bxcx)

# Create tcpl row objects
chms.loop <- chms
names(chms.loop) <- chms.loop
rows_n <- lapply(mc0_n, function (list) {
            data <- list[["data"]]
            lam.hat <- list[["lam.hat"]]
            shift <- list[["shift"]]
            lapply(chms.loop, function (chm) {
                          gabi::as_row(data, chemical=chm, lam.hat = lam.hat, shift = shift)})})
# Get hitcalls
tcplfits_n <- lapply(1:61, function (chm) {
                            to_fit <- lapply(rows_n, `[[`, chm)
                            lapply(to_fit, function(row) {
                                             gabi::concRespCoreZR(row, do.plot = TRUE)})})
names(tcplfits_n) <- chms
hitcalls_n <- lapply(tcplfits_n, function(chm) lapply(chm, function(endp) endp[["summary"]]$hitcall))
activecalls_n <- lapply(hitcalls_n, function(endp) which(endp >= 0.8))

# Fit and plot concResp curves. Make sure to set working directory
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
                  dev.off()})
  setwd("..")})

# Heat maps

## hitcall heatmap

## gather hits to plot in heatmap
l <- lapply(hitcalls_n, function(chm) unlist(chm))
hits <- do.call("rbind", l); rm(l)


## create df for annotating endpoints
ann.df <- data.frame(Phase = c(rep("Light",5), rep("Transition",3), rep("Dark",5), rep("Light + Dark",3)))
row.names(ann.df) <- ac

ann_colors <- c(Light = "white", Transition = "grey", Dark = "Black", `Light + Dark` = "red")
pheatmap::pheatmap(hits,
                   main = "Hitcall Heatmap for DNT60 Chemicals",
                   cluster_rows = T, cluster_cols = F,
                   cutree_rows = 6,
                   color = viridis::viridis(9),
                   annotation_col = ann.df, annotation_colors = list(Phase=ann_colors),
                   clustering_method = "ward.D2")

## hitcall heatmap with direction

## gather data
hits.dir <- lapply(tcplfits_n, function(chm) lapply(chm, function(endp) endp[["summary"]]$hitcall*sign(endp[["summary"]]$top)))
temp <- lapply(hits.dir, function(chm) unlist(chm))
hits.dir <- do.call("rbind", temp); rm(temp)
hits.dir <- hits.dir[, ac]

## create heatmap
breaks <- seq(from=-1, to=1, by=0.25)
colors <- rev(RColorBrewer::brewer.pal(length(breaks)-1, "RdBu"))
dir.hitsmap <- pheatmap::pheatmap(hits.dir,
                   main = "Directional Hitcall Heatmap for DNT60 Chemicals",
                   clustering_method = "ward.D2",
                   cluster_rows = T, cluster_cols = F,
                   cutree_rows = 7,
                   breaks = breaks,
                   color = colors,
                   annotation_col = ann.df, annotation_colors = list(Phase=ann_colors))

## extract chemical order after clustering
order <- dir.hitsmap$tree_row$order

# BMD heat map

## bmd.rng needs to be adjusted
labs <- paste0(-2:4,"\U03BC","M")
bmd <- lapply(tcplfits_n, function(chm) unlist(lapply(chm, function(fit) {
                                                            hitcall <- fit[["summary"]]$hitcall
                                                            bmd <- fit[["summary"]]$bmd
                                                            if (!(hitcall>0.8 & !is.na(bmd) & bmd != 0)) {
                                                              bmd <- 10000
                                                            }
                                                            bmd
                                                           })))
bmd <- do.call("rbind", bmd)
bmd <- log10(bmd[, ac])

## fit heat map with BMD values by chemical-endpoint pair
labs <- c(-2:3,paste0("4 log(","\U03BC","M)"))
bmdmap <- pheatmap::pheatmap(bmd[x,],
                   main = "BMC's of DNT60 Chemicals Active in \n Zebrafish Larval Photomotor Response Assay",
                   cluster_rows = T, cluster_cols = F,
                   color = rev(viridis(8)),
                   legend_breaks = -2:4,
                   legend_labels = labs,
                   annotation_col = ann.df, annotation_colors = list(Phase=ann_colors))

# create heatmap of maximum observed response

## gather data
deviation <- lapply(rows_n, function(endp) lapply(endp, function(row) {
  means <- tapply(row$resp, row$conc, mean, na.rm=TRUE)
  i <- which.max(abs(means))
  max <- means[i]

  max / row$onesd
}))
deviation <- lapply(deviation, function(endp) lapply(endp, function(deviation) {as.data.table(deviation,keep.rownames="conc")})) %>%
  lapply(., function(endp) do.call("rbind", endp)) %>%
  do.call("cbind", .)
row.names(deviation) <- chms

## create heatmap
deviation.val <- as.matrix(deviation[, grep("deviation",names(deviation),value=TRUE),with = FALSE])
colnames(deviation.val) <- gsub(".deviation", "", colnames(deviation.val))
deviation.conc <- deviation[, grep("conc",names(deviation),value=TRUE), with = FALSE][, lapply(.SD,as.numeric)][, lapply(.SD,formatC,format="e",digits=2)]
deviationMap <- pheatmap::pheatmap(deviation.val[order,],
         main = paste0("Maximum Observed Deviation from Control Mean in SDs \n Text in Cells is Concentration (",
                       "\U03BC","M) Where Maximum was Observed"),
         display_numbers = deviation.conc,
         cluster_rows = F, cluster_cols = F,
         color = colors,
         annotation_col = ann.df, annotation_colors = list(Phase=ann_colors))

# save heatmaps as .pngs

##make sure to set working directory
png("Directional hitsmap_DNT60.png",
    width = 720,
    height = 720)
print(dir.hitsmap)
dev.off()

png("Padilla_DNT60_BMC heatmap_Actives.png",
    width = 720,
    height = 720)
print(bmdmap)
dev.off()

png("deviationMap_DNT60.png",
    width = 1080,
    height = 1080)
print(deviationMap)
dev.off()

png("Fluoxetine_forPoster.png",
    width = 480,
    height = 480)
print(plot)
dev.off()

png("Amphetamine1_forPoster.png",
    width = 480,
    height = 480)
print(plot1)
dev.off()

png("Amphetamine2_forPoster.png",
    width = 480,
    height = 480)
print(plot2)
dev.off()

col_labels <- c("AUC in Light", "Average Speed in Light", "Average Acceleration in Light", "Average Jerk in Light", "Habituation in Light",
                "Startle Acceleration", "Startle Acceleration vs. Average", "Startle Fold-Change",
                "AUC in Dark", "Average Speed in Dark", "Average Acceleration in Dark", "Average Jerk in Dark", "Habituation in Dark",
                "AUC in Both Phases", "Average Speed in Both Phases", "AUC_D/AUC_L Ratio")

setHook("grid.newpage", function() pushViewport(viewport(x=1,y=1,width=0.9, height=0.9, name="vp", just=c("right","top"))), action="prepend")
pheatmap::pheatmap(bmd[x,],
                   main = "BMC's of DNT60 Chemicals Active in Zebrafish Larval Photomotor Response Assay",
                   cluster_rows = T, cluster_cols = F,
                   color = rev(viridis(8)),
                   angle_col = 45,
                   legend_breaks = -2:4,
                   legend_labels = labs,
                   labels_col = col_labels,
                   annotation_col = ann.df, annotation_colors = list(Phase=ann_colors))
setHook("grid.newpage", NULL, "replace")
grid.text("Endpoint", y=-0.03, x=0.35, gp=gpar(fontsize=12))
#grid.text("Chemical Name", x=-0.07, rot=90, gp=gpar(fontsize=12))
