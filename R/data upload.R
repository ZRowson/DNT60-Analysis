## ---------------------------
##
## Script Name: lmr0 Formatting of DNT60 Data
##
## Purpose of Script: Format DNT60 Data Prior to gabi Analysis.
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
library(readxl)
library(here)

here::i_am("R/data upload.R")


# Functions ---------------------------------------------------------------


as_lmr0 <- function(data, file.name = NULL) {
  table <- data.table::copy(data)

  # Some tables were uploaded with column names in first row
  # Check and edit if TRUE
  if (names(table)[10] == "...10") {
    names(table) <- as.character(table[1,])
    table <- table[-1,]
  }

  # Find column names that correspond with certain descriptors
  names <- names(table)
  kywrds <- c("chem", "plat", "\\..|well", "Status|SB", "conc")
  dptrs <- sapply(kywrds, function(kywrd) grep(kywrd, names, value=TRUE, ignore.case=TRUE))
  names(dptrs) <- c("cpid", "apid", "rowcol", "wllq", "conc")

  # Rename columns already in lmr0 format with lmr0 column names
  data.table::setnames(table, dptrs[c("cpid", "apid", "conc")], c("cpid", "apid", "conc"))
  # Rename time period columns
  tps <- grep("-", names, value = TRUE)
  newtps <- paste0("vt", seq(1, length(tps), by=1))
  data.table::setnames(table, tps, newtps)

  # Add lmr0 formatted columns to table
  srcf <- file.name
  acid <- "ZFlmrALD-20-40-40"
  table[, `:=` (srcf = srcf, acid = acid)]
  # Create rowi and coli columns by separating rowcol
  rowcol <- table[[dptrs[["rowcol"]]]]
  row <- sapply(rowcol, function (pos) substring(pos, 1, 1)) %>%
    match(LETTERS)
  col <- sapply(rowcol, function (pos) substring(pos, 2)) %>%
    as.integer()
  table[, `:=` (rowi = row, coli = col)]
  # Create wllt column
  table[, wllt := "t"][cpid %in% c("DMSO", "Water"), wllt := "v"] # this could throw errors if spelling errors are made, think about using grepl
  # Create wllq column
  qlty <- table[[dptrs[["wllq"]]]]
  gdqlty <- which(qlty == "Normal" | is.na(qlty))
  table[, wllq := 0][gdqlty, wllq := 1][is.na(as.numeric(vt1)), wllq := 0]

  # Some tables have statistics embedded in their rows. Remove those rows
  if (TRUE %in% table[, grepl("mean|count|sem", conc, ignore.case = TRUE)]) { # This is probably a pretty wonky logical. How do you apply grepl to a vector of strings?
    remove <- grep("mean|count|sem", table[, conc], ignore.case = TRUE)
    table <- table[-remove, ]
  }
  # Remove rows that are blank
  table <- table[!is.na(cpid)]

  # Ensure concentration and behavior data is of numeric class
  table[, (c("conc", newtps)) := lapply(.SD, as.numeric), .SDcols = c("conc", newtps)]

  # Create lmr0 table
  lmrcol <- c("srcf", "acid", "cpid", "apid", "rowi",
              "coli", "wllt", "wllq", "conc", newtps)
  lmr0 <- table[, ..lmrcol]

  return(lmr0)
}
upload_DNT60 <- function(path) { # This function prints warnings from data.table. Figure out why and fix it
  sheetnames <- readxl::excel_sheets(path)
  names(sheetnames) <- sheetnames
  # Upload all sheets from .xlsx file as data.tables
  tables <- lapply(sheetnames,
                   function(sheet) {
                     data.table::as.data.table(readxl::read_excel(path, sheet = sheet))
                   }
  )
  # Format tables according to lmr0 format
  tbls_lmr0 <- lapply(tables, function(table) as_lmr0(table, file.name = "All Chemicals one per sheet.xlsx"))
  # Create one large table of all chemicals via row binding and remove duplicate controls
  lmr0 <- data.table::rbindlist(tbls_lmr0, use.names = TRUE) %>%
    unique()

  return(lmr0)
}


# Transform data to lmr0 format -------------------------------------------

# Make sure to declare functions above first
path <- "../pipelining/raw data/editted All Chemicals one per sheet.xlsx"
lmr0 <- upload_DNT60(path)

# Change chemical names
new.chemical.names <- c("5,5-Diphenylhydantoin",
                        "5-Fluorouracil",
                        "6-Aminonicotinamide",
                        "6-Propyl-2-thiouracil",
                        "Acetaminophen",
                        "Acrylamide",
                        "Aldicarb",
                        "Amoxicillin",
                        "Amphetamine",
                        "Arsenic",
                        "Bisphenol A (BPA)",
                        "Bis(tributyltin) oxide",
                        "Cadmium chloride",
                        "Caffeine",
                        "Captopril",
                        "Carbamazepine",
                        "Chloramben",
                        "Chlorpyrifos",
                        "Chlorpyrifos oxon",
                        "Cocaine base",
                        "Colchicine",
                        "Cotinine",
                        "Cyclophosphamide",
                        "Cytosine arabinoside",
                        "Deltamethrin",
                        "Dexamethazone",
                        "Di(2-ethylhexyl)phthalate (DEHP)",
                        "Diazepam",
                        "Dieldrin",
                        "Diethylene glycol",
                        "Diethylstilbesterol",
                        "D-sorbitol",
                        "Fluconazole",
                        "Fluoxetine",
                        "Glyphosate",
                        "Haloperidol",
                        "Heptachlor",
                        "Heptachlor epoxide",
                        "Hexachlorophene",
                        "Hydoxyurea",
                        "Isoniazid",
                        "Lead acetate",
                        "Loperamide",
                        "Maneb",
                        "Manganese",
                        "Methotrexate",
                        "Naloxon",
                        "Nicotine",
                        "Paraquat",
                        "Permethrin",
                        "Phenobarbital",
                        "Phenol",
                        "Polybrominated diphenyl ether (PBDE)-47",
                        "Saccharin",
                        "Sodium benzoate",
                        "Sodium fluoride",
                        "Tebuconazole",
                        "Terbutaline",
                        "Thalidomide",
                        "Triethyltin",
                        "Valproate",
                        "Water",
                        "DMSO")
old.chemical.names <- c("5,5-diphenylhydandoin",
                        "5-Fluorouracil",
                        "6-Aminonicotinamide",
                        "6-propyl-2-thiouracil",
                        "Acetaminophen",
                        "Acrylamide",
                        "Aldicarb",
                        "Amoxicillin",
                        "Amphetamine",
                        "Arsenic",
                        "BPA",
                        "TBT (#65)",
                        "Cadmium chloride",
                        "Caffeine",
                        "Captopril",
                        "Carbamazepine",
                        "Chloramben",
                        "Chlorpyrifos",
                        "Chlorpyrifos oxon",
                        "Cocaine Base",
                        "Colchicine",
                        "Cotinine (#77)",
                        "Cyclophosphamide",
                        "Cytosine β-D-arabinofuranoside",
                        "Deltamethrin",
                        "Dexamethazone",
                        "DEHP",
                        "Diazepam",
                        "Dieldrin",
                        "Diethylene Glycol (#75)",
                        "DES (#55)",
                        "D-sorbitol",
                        "Fluconazole (#80)",
                        "Fluoxetine",
                        "Glyphosate",
                        "Haloperidol",
                        "Heptachlor",
                        "Heptachlor epoxide",
                        "Hexachlorophene (#15)",
                        "Hydroxyurea",
                        "Isoniazid (#60)",
                        "Lead acetate",
                        "Loperamide",
                        "Maneb",
                        "Manganese",
                        "Methotrexate",
                        "Naloxon",
                        "Nicotine (#36)",
                        "Paraquat",
                        "Permethrin",
                        "Phenobarbital",
                        "Phenol",
                        "PBDE-47",
                        "Saccharin",
                        "Sodium benzoate",
                        "Sodium Fluoride",
                        "Tebuconazole",
                        "Terbutaline",
                        "Thalidomide (#59)",
                        "Triethyl Tin",
                        "Valproate",
                        "Water",
                        "DMSO")

lapply(1:63, function(i) {
  old.name <- old.chemical.names[i]
  new.name <- new.chemical.names[i]
  lmr0[cpid==old.name, cpid := new.name]
})

## Remove test concentration groups that do not meet quality thresholds
## Threshold: sample proportion of good quality test subjects = 0.75
remove <- lmr0[wllt == "t", .(p.hat = (sum(wllq==1) / .N)), by = .(cpid,conc)][p.hat < .75, .(cpid, conc)]
lmr0.1 <- lmr0[!remove, on = .(cpid=cpid, conc=conc)]
rm(lmr0)
lmr0 <- data.table::copy(lmr0.1)

# Remove behavior data and save info on sizes of treatment groups and plate number
lmr0.egid <- gabi::data_egids(lmr0.1)
tmc0 <- lmr0.egid[, .N, by=.(srcf,acid,cpid,conc,egid,wllq)]

# save mc0 formatted data
save(lmr0, file = "raw data/Padilla_DNT60_lmr0.Rdata")
save(lmr0.egid, file = "raw data/Padilla_DNT60_lmr0_w_egid.Rdata")
save(tmc0, file = "raw data/Padilla_DNT60_treatmentN.Rdata")


# Clear Environment -------------------------------------------------------


rm(list = ls())
