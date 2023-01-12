---
title: "gabi Analysis of DNT60 Results Summarization"
author: "Zachary Rowson"
date: "10/14/2021"
output: html_document
---



## Introduction

This document will summarize the results of a gabi analysis of Padilla lab ZFpmr behavioral assays of DNT60 chemicals for developmental neurotoxicity.

This document will summarize...

* Activity by endpoint (hitcall > 0.8 implies activity)
  + number of chemicals active per endpoint
  + group chemicals by which endpoint they are found active in
* Activity by experimental period
  + activity profiles of chemicals by experimental periods
  + groups of chemicals sharing the same activity profile
  + number of chemicals found active in each experimental period (Freeze, Light, Startle, Dark)
* activity by chemical
  + for each chemical list their endpoint activity profile
  + number of endpoints a chemical was active in
  + group chemicals that share endpoint-activity profiles
* obtain BMD ranges
  + for all chemicals
  + for only chemicals found active in at least one endpoint
  
## Activity by Endpoint

### Count Hits per Endpoint
![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)

### List Chemicals Active per Endpoint

```
## $AUC_L
## [1] "6-Aminonicotinamide, Amphetamine, Cocaine Base, Diazepam, Fluoxetine, Loperamide"
## 
## $AUC_D
## [1] "6-Aminonicotinamide, BPA, Fluoxetine, Heptachlor, Paraquat, PBDE-47"
## 
## $AUC_T
## [1] "6-Aminonicotinamide, BPA, Diazepam, Fluoxetine, Heptachlor, Paraquat, PBDE-47"
## 
## $AUC_r
## [1] "Fluoxetine, Heptachlor epoxide, Loperamide, Paraquat, PBDE-47"
## 
## $avgS_L
## [1] "6-Aminonicotinamide, Amphetamine, Cocaine Base, Diazepam, Fluoxetine, Loperamide"
## 
## $avgS_D
## [1] "6-Aminonicotinamide, Acrylamide, BPA, Fluoxetine, Heptachlor, Paraquat, PBDE-47"
## 
## $avgS_T
## [1] "6-Aminonicotinamide, BPA, Diazepam, Fluoxetine, Heptachlor, Paraquat, PBDE-47"
## 
## $avgA_L
## [1] "Amphetamine, D-sorbitol, Heptachlor, Loperamide, Tebuconazole"
## 
## $avgA_D
## [1] "5,5-diphenylhydandoin, Chlorpyrifos, TBT (#65), Tebuconazole"
## 
## $avgJ_L
## [1] ""
## 
## $avgJ_D
## [1] ""
## 
## $frzA
## [1] "Heptachlor, Naloxon, Phenobarbital, Triethyl Tin"
## 
## $frzF
## [1] "Heptachlor"
## 
## $strtlA
## [1] "D-sorbitol"
## 
## $strtlAavg
## [1] "Acrylamide, Chlorpyrifos, D-sorbitol, DES (#55), Dieldrin, Paraquat, Tebuconazole"
## 
## $strtlF
## [1] "Amphetamine, Loperamide, Phenobarbital, Triethyl Tin"
## 
## $hbt_L
## [1] "6-Aminonicotinamide, Cocaine Base, Diazepam, Fluoxetine"
## 
## $hbt_D
## [1] "5-Fluorouracil, Paraquat"
```

## Activity by Experimental Period

### Number of Chemicals Active per Experimental Period

Activity in an experimental period is defined as having at least one hitcall > 0.8 in an endpoint that describes that experimental period.

### List Chemicals Activity Profiles in Terms of Experimental Period

1 indicates activity in a period and 0 indicates inactivity.
![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)

### Group Chemicals with similar Activity Profiles by Experimental Period

```
## $`0000`
## [1] "6-propyl-2-thiouracil, Acetaminophen, Aldicarb, Amoxicillin, Arsenic, Cadmium chloride, Caffeine, Captopril, Carbamazepine, Chloramben, Chlorpyrifos oxon, Colchicine, Cotinine (#77), Cyclophosphamide, Cytosine β-D-arabinofuranoside, DEHP, Deltamethrin, Dexamethazone, Diethylene Glycol (#75), Fluconazole (#80), Glyphosate, Haloperidol, Heptachlor epoxide, Hexachlorophene (#15), Hydroxyurea, Isoniazid (#60), Lead acetate, Maneb, Manganese, Methotrexate, Nicotine (#36), Permethrin, Phenol, Saccharin, Sodium benzoate, Sodium Fluoride, Terbutaline, Thalidomide (#59), Valproate"
## 
## $`0001`
## [1] "5,5-diphenylhydandoin, 5-Fluorouracil, TBT (#65), BPA, PBDE-47"
## 
## $`0010`
## [1] "DES (#55), Dieldrin"
## 
## $`0011`
## [1] "Acrylamide, Chlorpyrifos, Paraquat"
## 
## $`0100`
## [1] "Cocaine Base, Diazepam"
## 
## $`0101`
## [1] "6-Aminonicotinamide, Fluoxetine"
## 
## $`0110`
## [1] "Amphetamine, D-sorbitol, Loperamide"
## 
## $`0111`
## [1] "Tebuconazole"
## 
## $`1000`
## [1] "Naloxon"
## 
## $`1001`
## [1] ""
## 
## $`1010`
## [1] "Phenobarbital, Triethyl Tin"
## 
## $`1011`
## [1] ""
## 
## $`1100`
## [1] ""
## 
## $`1101`
## [1] "Heptachlor"
## 
## $`1110`
## [1] ""
## 
## $`1111`
## [1] ""
```

### Count Actives per Period

```
##  Freeze   Light Startle    Dark 
##       4       9      11      12
```

## Activity by Chemical

### Activity Profiles of Chemicals by Endpoints

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png)

### Number of Active Endpoints per Chemical

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png)

### Group Chemicals with similar Activity Profiles by Endpoints

```
## $`Only avgS_L`
## [1] "5,5-diphenylhydandoin, TBT (#65)"
## 
## $Inactives
## [1] "6-propyl-2-thiouracil, Acetaminophen, Aldicarb, Amoxicillin, Arsenic, Cadmium chloride, Caffeine, Captopril, Carbamazepine, Chloramben, Chlorpyrifos oxon, Colchicine, Cotinine (#77), Cyclophosphamide, Cytosine β-D-arabinofuranoside, DEHP, Deltamethrin, Dexamethazone, Diethylene Glycol (#75), Fluconazole (#80), Glyphosate, Haloperidol, Hexachlorophene (#15), Hydroxyurea, Isoniazid (#60), Lead acetate, Maneb, Manganese, Methotrexate, Nicotine (#36), Permethrin, Phenol, Saccharin, Sodium Fluoride, Sodium benzoate, Terbutaline, Thalidomide (#59), Valproate"
## 
## $`Only hbt_L`
## [1] "DES (#55), Dieldrin"
## 
## $`frzA and hbt_D`
## [1] "Phenobarbital, Triethyl Tin"
```

## BMD Ranges

### BMD Ranges for Active Chemicals

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png)

### BMD Ranges for All Chemicals

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10-1.png)