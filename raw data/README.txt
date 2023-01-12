#######################################################################################
# This document describes the raw data contained in DNT60Analsis pipelining/raw data
#######################################################################################

#### Padilla_DNT60_treatmentN.Rdata

This data describes the sample sizes of treatment and vehicle control groups by providing the count of
fish within a group that were of good quality (wllq = 1) or bad quality (wllq = 0). Bad quality fish were removed from behavior analysis. The sum of these two values provides the complete sample size.

#### Padilla_DNT60_ChemConcs Excluded.Rdata

This file contains chemical-concentration group pairs that were excluded from analysis. Treatment groups are excluded from behavior analysis if less than 75% of subjects in sample were deemed acceptable for behavior analysis.

#### Padilla_DNT60_lmr0.Rdata

This dataset contains zebrafish tracking data from the Padilla DNT60 analysis. Tracking measurements are given for each zebrafish in wide format such that each row corresponds to an individual zebrafish. Chemical, concentration, plate, well location, and well quality information are all provided.

To see more detailed description of "lmr0" formatted datasets in general see gabi package documentation, gabi::as_mc0.

#### Padilla_DNT60_lmr0_w_egid.Rdata

Same as above but with addition of egid column which specifies experimental group. Using values in this column vehicle control groups and all chemical exposures that were run in parallel with the group and can be extracted at once.

#### Padilla_DNT60_Experimental Groups Excluded.Rdata

Experimental groups excluded from analysis. Experimental groups are excluded from behavior analysis if vehicle control sample has less than 85% of zebrafish deemed acceptable for behavior analysis.

#### editted All Chemicals one per sheet.xlsx

Raw tracking data provided from Padilla lab. Data for each chemical exposure is provided on individual sheets in an Excel file.
