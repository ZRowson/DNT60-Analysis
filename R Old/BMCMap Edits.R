## ---------------------------
##
## Script Name: BMC Graphic for DNT60 Chemicals
##
## Purpose of Script: Make a good BMC graphic for DNT60 chemicals.
##
## Author: Zachary Rowson
##
## Date Created: 2022-02-18
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
library(pheatmap)
library(gridExtra)
library(viridis)
library(grid)


# Clustering callback
callback <- function(hc, mat){
  if(length(hc$labels) == 16) {
    hc$order <- hc$order[c(3,4,5,8,2,6,15,1,12,11,16,9,7,13,14,10)]
    hc$merge <- matrix(c(-1,-3,-4,-5,-6,-8,-9,-11,-12,-13,-14,-16,4,10,12,
                         -2,1,2,3,-7,5,-10,7,8,9,-15,11,6,6,10),ncol=2)
  }
  return(hc)
}

# Print BMC heatmap
setHook("grid.newpage", function() pushViewport(viewport(x=1,y=1,width=0.9, height=0.9, name="vp", just=c("right","top"))), action="prepend")
bmd.col <- pheatmap::pheatmap(bmd,
                   main = "BMC's of DNT60 Chemicals Active in \n Zebrafish Larval Photomotor Response Assay",
                   cluster_rows = T, cluster_cols = T, clustering_callback = callback, cutree_cols = 4,
                   treeheight_col = 0,
                   color = rev(viridis(8)),
                   angle_col = 45,
                   legend_breaks = -2:4,
                   legend_labels = labs,
                   labels_col = col_labels,
                   annotation_col = ann.df, annotation_colors = list(Phase=ann_colors),
                   fontsize = 16)
setHook("grid.newpage", NULL, "replace")
grid.text(expression(bold("Endpoint")), y=-0.03, x=0.33, gp=gpar(fontsize=16))
