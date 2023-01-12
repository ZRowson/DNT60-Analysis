# Upload DNT60 data
# Rowson.Zachary@epa.gov
# created: 09/24/2021
# last edit 09/29/2021

library(readxl)
library(data.table)
library(magrittr)
library(gabi)

# function that puts "All Chemicals one per Sheet data into pmr0 format
as_pmr0 <- function(data, path = NULL) {
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

  # Rename columns already in pmr0 format with pmr0 column names
  data.table::setnames(table, dptrs[c("cpid", "apid", "conc")], c("cpid", "apid", "conc"))
  # Rename time period columns
  tps <- grep("-", names, value = TRUE)
  newtps <- paste0("vt", seq(1, length(tps), by=1))
  data.table::setnames(table, tps, newtps)

  # Add pmr0 formatted columns to table
  srcf <- path
  acid <- "ZFpmrALD-20-40-40"
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
  table[, wllq := 0][gdqlty, wllq := 1][is.na(vt1), wllq := 0]

  # Some tables have statistics embedded in their rows. Remove those rows
  if (TRUE %in% table[, grepl("mean|count|sem", conc, ignore.case = TRUE)]) { # This is probably a pretty wonky logical. How do you apply grepl to a vector of strings?
    remove <- grep("mean|count|sem", table[, conc], ignore.case = TRUE)
    table <- table[-remove, ]
  }
  # Remove rows that are blank
  table <- table[!is.na(cpid)]

  # Ensure concentration and behavior data is of numeric class
  table[, (c("conc", newtps)) := lapply(.SD, as.numeric), .SDcols = c("conc", newtps)]

  # Create pmr0 table
  pmrcol <- c("srcf", "acid", "cpid", "apid", "rowi",
              "coli", "wllt", "wllq", "conc", newtps)
  pmr0 <- table[, ..pmrcol]

  return(pmr0)
}

# upload data from editted All Chemicals one per sheet

## upload all sheets from .xlsx file as data.tables
path <- "data/editted All Chemicals one per sheet.xlsx"
sheetnames <- readxl::excel_sheets(path)
names(sheetnames) <- sheetnames
tables <- lapply(sheetnames,
   function(sheet) {
     data.table::as.data.table(readxl::read_excel(path, sheet = sheet))
   })

# format tables according to pmr0 format

tbls_pmr0 <- lapply(tables, function(table) as_pmr0(table, path = "All Chemicals one per sheet.xlsx"))
## create one large table of all chemicals via row binding and remove duplicate controls
temp <- data.table::rbindlist(tbls_pmr0, use.names = TRUE) %>%
          unique()
## remove test concentration groups that do not meet quality thresholds
## threshold: sample proportion of good quality test subjects = 0.75
remove <- temp[wllt == "t", .(p.hat = (sum(wllq==1) / .N)), by = .(cpid,conc)][p.hat < .75, .(cpid, conc)] # this only removes bad test groups, do I have to worry about
pmr0 <- temp[!remove, on = .(cpid=cpid, conc=conc)]
rm(temp, tables, tbls_pmr0, remove, sheetnames, as_pmr0)

x <- as.data.table(pmr0); rm(pmr0)
pmr0 <- copy(x); rm(x)

# save pmr0
write.csv(pmr0, file = "data/DNT60 pmr0", row.names = FALSE)
