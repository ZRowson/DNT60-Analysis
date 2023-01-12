---
title: "Graphical Summary for Fluoxetine"
author: "Zachary Rowson"
date: "10/27/2021"
output: html_document
---



## Introduction

This document will graphically summarize gabi analysis results for Fluoxetine and display graphics that summarize results for the DNT60 set.


```r
# declare chemical name and index
chemical <- "Fluoxetine"
i <- which(chms == "Fluoxetine")

# gather experimental group number for Fluoxetine
group <- unique(gabi::data_egids(pmr0)[cpid==chemical, egid])
```

```
## Error in `[.data.frame`(table, wllt == "t", .(apids = .(unique(c(apid)) %>% : unused argument (by = cpid)
```

```r
# isolate relevant rows
rows <- lapply(rows_n, `[[`, i)
```

## Graphics specific to Individual Chemicals

### Time Series Visualizations


```r
gabi::plot_tSeries(pmr0, chemical = chemical, prsp = "SS")
```

```
## Warning: Removed 320 rows containing missing values (geom_point).
```

```
## Warning: Removed 320 row(s) containing missing values (geom_path).
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)

```r
gabi::plot_tSeries(pmr0, chemical = chemical, prsp = "PA")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-2.png)

### Endpoint Distributions: Before and After Transform


```r
lapply(mc0, function(data) {
  gabi::plot_eDist(data, chemical = chemical)
})
```

```
## $AUC_L
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).
```

```
## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)

```
## 
## $AUC_D
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-2.png)

```
## 
## $AUC_T
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-3.png)

```
## 
## $AUC_r
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-4.png)

```
## 
## $avgS_L
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-5.png)

```
## 
## $avgS_D
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-6.png)

```
## 
## $avgS_T
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-7.png)

```
## 
## $avgA_L
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-8.png)

```
## 
## $avgA_D
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-9.png)

```
## 
## $avgJ_L
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-10.png)

```
## 
## $avgJ_D
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-11.png)

```
## 
## $frzA
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-12.png)

```
## 
## $frzF
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-13.png)

```
## 
## $strtlA
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-14.png)

```
## 
## $strtlAavg
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-15.png)

```
## 
## $strtlF
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-16.png)

```
## 
## $hbt_L
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-17.png)

```
## 
## $hbt_D
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-18.png)

```r
lapply(mc0_n, function(endp) {
  data <- endp[[1]]
  gabi::plot_eDist(data, chemical = chemical)
})
```

```
## $AUC_L
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-19.png)

```
## 
## $AUC_D
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-20.png)

```
## 
## $AUC_T
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-21.png)

```
## 
## $AUC_r
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-22.png)

```
## 
## $avgS_L
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-23.png)

```
## 
## $avgS_D
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-24.png)

```
## 
## $avgS_T
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-25.png)

```
## 
## $avgA_L
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-26.png)

```
## 
## $avgA_D
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-27.png)

```
## 
## $avgJ_L
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-28.png)

```
## 
## $avgJ_D
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-29.png)

```
## 
## $frzA
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-30.png)

```
## 
## $frzF
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-31.png)

```
## 
## $strtlA
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-32.png)

```
## 
## $strtlAavg
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-33.png)

```
## 
## $strtlF
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-34.png)

```
## 
## $hbt_L
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-35.png)

```
## 
## $hbt_D
```

```
## Warning: Removed 8 rows containing non-finite values (stat_boxplot).

## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-36.png)

### Benchmark Concentration Analyses


```r
fits <- lapply(rows, gabi::concRespCoreZR, do.plot = TRUE)
lapply(fits, `[[`, "plot")
```

```
## $AUC_L
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)

```
## 
## $AUC_D
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-2.png)

```
## 
## $AUC_T
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-3.png)

```
## 
## $AUC_r
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-4.png)

```
## 
## $avgS_L
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-5.png)

```
## 
## $avgS_D
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-6.png)

```
## 
## $avgS_T
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-7.png)

```
## 
## $avgA_L
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-8.png)

```
## 
## $avgA_D
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-9.png)

```
## 
## $avgJ_L
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-10.png)

```
## 
## $avgJ_D
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-11.png)

```
## 
## $frzA
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-12.png)

```
## 
## $frzF
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-13.png)

```
## 
## $strtlA
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-14.png)

```
## 
## $strtlAavg
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-15.png)

```
## 
## $strtlF
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-16.png)

```
## 
## $hbt_L
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-17.png)

```
## 
## $hbt_D
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-18.png)

## Study-Level Summarizing Graphics

### Heatmaps: Hitcalls and BMDs


```r
pheatmap::pheatmap(hits, 
                   main = "Hitcall Heatmap for DNT60 Chemicals",
                   cluster_rows = T, cluster_cols = F,
                   cutree_rows = 6,
                   color = viridis::viridis(9),
                   annotation_col = ann.df, annotation_colors = list(Phase=ann_colors))
```

```
## Warning in strwidth(t, units = "in", cex = fontsize_row/fontsize): conversion
## failure on 'Cytosine β-D-arabinofuranoside' in 'mbcsToSbcs': dot substituted for
## <ce>
```

```
## Warning in strwidth(t, units = "in", cex = fontsize_row/fontsize): conversion
## failure on 'Cytosine β-D-arabinofuranoside' in 'mbcsToSbcs': dot substituted for
## <b2>
```

```
## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
## conversion failure on 'Cytosine β-D-arabinofuranoside' in 'mbcsToSbcs': dot
## substituted for <ce>
```

```
## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
## conversion failure on 'Cytosine β-D-arabinofuranoside' in 'mbcsToSbcs': dot
## substituted for <b2>
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)

```r
pheatmap::pheatmap(to_fit, 
                   main = "BMD Heatmap for DNT60 Chemicals",
                   cluster_rows = F, cluster_cols = F,
                   cutree_rows = 6,
                   color = viridis::viridis(9),
                   annotation_col = ann.df, annotation_colors = list(Phase=ann_colors))
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-2.png)

### Venn/Euler Diagrams

```
## Loading required package: grid
```

```
## Loading required package: futile.logger
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png)![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-2.png)![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-3.png)![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-4.png)![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-5.png)

```
## [[1]]
##                               cpid Freeze Light Startle Dark
##  1:          5,5-diphenylhydandoin      0     0       0    1
##  2:                 5-Fluorouracil      0     0       0    1
##  3:            6-Aminonicotinamide      0     1       0    1
##  4:          6-propyl-2-thiouracil      0     0       0    0
##  5:                  Acetaminophen      0     0       0    0
##  6:                     Acrylamide      0     0       1    1
##  7:                       Aldicarb      0     0       0    0
##  8:                    Amoxicillin      0     0       0    0
##  9:                    Amphetamine      0     1       1    0
## 10:                        Arsenic      0     0       0    0
## 11:                      TBT (#65)      0     0       0    1
## 12:                            BPA      0     0       0    1
## 13:               Cadmium chloride      0     0       0    0
## 14:                       Caffeine      0     0       0    0
## 15:                      Captopril      0     0       0    0
## 16:                  Carbamazepine      0     0       0    0
## 17:                     Chloramben      0     0       0    0
## 18:                   Chlorpyrifos      0     0       1    1
## 19:              Chlorpyrifos oxon      0     0       0    0
## 20:                   Cocaine Base      0     1       0    0
## 21:                     Colchicine      0     0       0    0
## 22:                 Cotinine (#77)      0     0       0    0
## 23:               Cyclophosphamide      0     0       0    0
## 24: Cytosine β-D-arabinofuranoside      0     0       0    0
## 25:                           DEHP      0     0       0    0
## 26:                   Deltamethrin      0     0       0    0
## 27:                      DES (#55)      0     0       1    0
## 28:                  Dexamethazone      0     0       0    0
## 29:                       Diazepam      0     1       0    0
## 30:                       Dieldrin      0     0       1    0
## 31:        Diethylene Glycol (#75)      0     0       0    0
## 32:                     D-sorbitol      0     1       1    0
## 33:              Fluconazole (#80)      0     0       0    0
## 34:                     Fluoxetine      0     1       0    1
## 35:                     Glyphosate      0     0       0    0
## 36:                    Haloperidol      0     0       0    0
## 37:                     Heptachlor      1     1       0    1
## 38:             Heptachlor epoxide      0     0       0    0
## 39:          Hexachlorophene (#15)      0     0       0    0
## 40:                    Hydroxyurea      0     0       0    0
## 41:                Isoniazid (#60)      0     0       0    0
## 42:                   Lead acetate      0     0       0    0
## 43:                     Loperamide      0     1       1    0
## 44:                          Maneb      0     0       0    0
## 45:                      Manganese      0     0       0    0
## 46:                   Methotrexate      0     0       0    0
## 47:                        Naloxon      1     0       0    0
## 48:                 Nicotine (#36)      0     0       0    0
## 49:                       Paraquat      0     0       1    1
## 50:                        PBDE-47      0     0       0    1
## 51:                     Permethrin      0     0       0    0
## 52:                  Phenobarbital      1     0       1    0
## 53:                         Phenol      0     0       0    0
## 54:                      Saccharin      0     0       0    0
## 55:                Sodium benzoate      0     0       0    0
## 56:                Sodium Fluoride      0     0       0    0
## 57:                   Tebuconazole      0     1       1    1
## 58:                    Terbutaline      0     0       0    0
## 59:              Thalidomide (#59)      0     0       0    0
## 60:                   Triethyl Tin      1     0       1    0
## 61:                      Valproate      0     0       0    0
##                               cpid Freeze Light Startle Dark
## 
## [[2]]
##                               cpid Freeze Light Startle Dark
##  1:          5,5-diphenylhydandoin      0     0       0    1
##  2:                 5-Fluorouracil      0     0       0    1
##  3:            6-Aminonicotinamide      0     1       0    1
##  4:          6-propyl-2-thiouracil      0     0       0    0
##  5:                  Acetaminophen      0     0       0    0
##  6:                     Acrylamide      0     0       1    1
##  7:                       Aldicarb      0     0       0    0
##  8:                    Amoxicillin      0     0       0    0
##  9:                    Amphetamine      0     1       1    0
## 10:                        Arsenic      0     0       0    0
## 11:                      TBT (#65)      0     0       0    1
## 12:                            BPA      0     0       0    1
## 13:               Cadmium chloride      0     0       0    0
## 14:                       Caffeine      0     0       0    0
## 15:                      Captopril      0     0       0    0
## 16:                  Carbamazepine      0     0       0    0
## 17:                     Chloramben      0     0       0    0
## 18:                   Chlorpyrifos      0     0       1    1
## 19:              Chlorpyrifos oxon      0     0       0    0
## 20:                   Cocaine Base      0     1       0    0
## 21:                     Colchicine      0     0       0    0
## 22:                 Cotinine (#77)      0     0       0    0
## 23:               Cyclophosphamide      0     0       0    0
## 24: Cytosine β-D-arabinofuranoside      0     0       0    0
## 25:                           DEHP      0     0       0    0
## 26:                   Deltamethrin      0     0       0    0
## 27:                      DES (#55)      0     0       1    0
## 28:                  Dexamethazone      0     0       0    0
## 29:                       Diazepam      0     1       0    0
## 30:                       Dieldrin      0     0       1    0
## 31:        Diethylene Glycol (#75)      0     0       0    0
## 32:                     D-sorbitol      0     1       1    0
## 33:              Fluconazole (#80)      0     0       0    0
## 34:                     Fluoxetine      0     1       0    1
## 35:                     Glyphosate      0     0       0    0
## 36:                    Haloperidol      0     0       0    0
## 37:                     Heptachlor      1     1       0    1
## 38:             Heptachlor epoxide      0     0       0    0
## 39:          Hexachlorophene (#15)      0     0       0    0
## 40:                    Hydroxyurea      0     0       0    0
## 41:                Isoniazid (#60)      0     0       0    0
## 42:                   Lead acetate      0     0       0    0
## 43:                     Loperamide      0     1       1    0
## 44:                          Maneb      0     0       0    0
## 45:                      Manganese      0     0       0    0
## 46:                   Methotrexate      0     0       0    0
## 47:                        Naloxon      1     0       0    0
## 48:                 Nicotine (#36)      0     0       0    0
## 49:                       Paraquat      0     0       1    1
## 50:                        PBDE-47      0     0       0    1
## 51:                     Permethrin      0     0       0    0
## 52:                  Phenobarbital      1     0       1    0
## 53:                         Phenol      0     0       0    0
## 54:                      Saccharin      0     0       0    0
## 55:                Sodium benzoate      0     0       0    0
## 56:                Sodium Fluoride      0     0       0    0
## 57:                   Tebuconazole      0     1       1    1
## 58:                    Terbutaline      0     0       0    0
## 59:              Thalidomide (#59)      0     0       0    0
## 60:                   Triethyl Tin      1     0       1    0
## 61:                      Valproate      0     0       0    0
##                               cpid Freeze Light Startle Dark
## 
## [[3]]
##                               cpid Freeze Light Startle Dark
##  1:          5,5-diphenylhydandoin      0     0       0    1
##  2:                 5-Fluorouracil      0     0       0    1
##  3:            6-Aminonicotinamide      0     1       0    1
##  4:          6-propyl-2-thiouracil      0     0       0    0
##  5:                  Acetaminophen      0     0       0    0
##  6:                     Acrylamide      0     0       1    1
##  7:                       Aldicarb      0     0       0    0
##  8:                    Amoxicillin      0     0       0    0
##  9:                    Amphetamine      0     1       1    0
## 10:                        Arsenic      0     0       0    0
## 11:                      TBT (#65)      0     0       0    1
## 12:                            BPA      0     0       0    1
## 13:               Cadmium chloride      0     0       0    0
## 14:                       Caffeine      0     0       0    0
## 15:                      Captopril      0     0       0    0
## 16:                  Carbamazepine      0     0       0    0
## 17:                     Chloramben      0     0       0    0
## 18:                   Chlorpyrifos      0     0       1    1
## 19:              Chlorpyrifos oxon      0     0       0    0
## 20:                   Cocaine Base      0     1       0    0
## 21:                     Colchicine      0     0       0    0
## 22:                 Cotinine (#77)      0     0       0    0
## 23:               Cyclophosphamide      0     0       0    0
## 24: Cytosine β-D-arabinofuranoside      0     0       0    0
## 25:                           DEHP      0     0       0    0
## 26:                   Deltamethrin      0     0       0    0
## 27:                      DES (#55)      0     0       1    0
## 28:                  Dexamethazone      0     0       0    0
## 29:                       Diazepam      0     1       0    0
## 30:                       Dieldrin      0     0       1    0
## 31:        Diethylene Glycol (#75)      0     0       0    0
## 32:                     D-sorbitol      0     1       1    0
## 33:              Fluconazole (#80)      0     0       0    0
## 34:                     Fluoxetine      0     1       0    1
## 35:                     Glyphosate      0     0       0    0
## 36:                    Haloperidol      0     0       0    0
## 37:                     Heptachlor      1     1       0    1
## 38:             Heptachlor epoxide      0     0       0    0
## 39:          Hexachlorophene (#15)      0     0       0    0
## 40:                    Hydroxyurea      0     0       0    0
## 41:                Isoniazid (#60)      0     0       0    0
## 42:                   Lead acetate      0     0       0    0
## 43:                     Loperamide      0     1       1    0
## 44:                          Maneb      0     0       0    0
## 45:                      Manganese      0     0       0    0
## 46:                   Methotrexate      0     0       0    0
## 47:                        Naloxon      1     0       0    0
## 48:                 Nicotine (#36)      0     0       0    0
## 49:                       Paraquat      0     0       1    1
## 50:                        PBDE-47      0     0       0    1
## 51:                     Permethrin      0     0       0    0
## 52:                  Phenobarbital      1     0       1    0
## 53:                         Phenol      0     0       0    0
## 54:                      Saccharin      0     0       0    0
## 55:                Sodium benzoate      0     0       0    0
## 56:                Sodium Fluoride      0     0       0    0
## 57:                   Tebuconazole      0     1       1    1
## 58:                    Terbutaline      0     0       0    0
## 59:              Thalidomide (#59)      0     0       0    0
## 60:                   Triethyl Tin      1     0       1    0
## 61:                      Valproate      0     0       0    0
##                               cpid Freeze Light Startle Dark
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-6.png)
