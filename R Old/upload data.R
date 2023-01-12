# as_pmr0
# Rowson.Zachary@epa.gov
# created: 11/30/2021
# last edit 11/30/2021

library(data.table)
library(magrittr)
library(readxl)

# transorm "Copy of All 4 recordings in same file.xls" to pmr0 format

## copy data

table <- data.table::copy(data)

## identify columns of interest and rename

## find column names with grep
names <- names(table)
kywrds <- c("chem", "plat", "well", "Status|SB", "conc")
match <- sapply(kywrds, function(kywrd) grep(kywrd, names, value=TRUE, ignore.case=TRUE))
names(match) <- c("cpid", "apid", "rowcol", "wllq", "conc")

## Rename columns already in pmr0 format with pmr0 column names
data.table::setnames(table, match[c("cpid", "apid", "conc")], c("cpid", "apid", "conc"))

## Rename time period columns
t.old <- grep("\\..", names, value = TRUE)
t.new <- paste0("vt", 1:length(t.old))
data.table::setnames(table, t.old, t.new)

## add pmr0 columns

## add source file and assay component information
srcf <- path
acid <- "ZFpmrALD-20-40-40"
table[, `:=` (srcf = srcf, acid = acid)]

## Create row and column columns by separating rowcol and matching letters to numbers
rowcol <- table[[match[["rowcol"]]]]
row <- sapply(rowcol, function (pos) substring(pos, 1, 1)) %>%
        match(LETTERS)
col <- sapply(rowcol, function (pos) substring(pos, 2)) %>%
        as.integer()
table[, `:=` (rowi = row, coli = col)]

## create wllt column
table[, wllt := "v"]

## create wllq column
table[is.na(Status), wllq := 1]

## remove empty rows, perform final touches, and return pmr0 columns

## remove rows that are blank
table <- table[!is.na(cpid)]

## ensure concentration and behavior data is of numeric class
table[, (c("conc", t.new)) := lapply(.SD, as.numeric), .SDcols = c("conc", t.new)]

## create pmr0 formatted table
pmr0.cols <- c("srcf", "acid", "cpid", "apid", "rowi",
               "coli", "wllt", "wllq", "conc", t.new)
pmr0 <- table[, ..pmr0.cols]

## save other information in raw data in a table with keyes that match over to pmr0

## grab necessary columns
pmr0.excess.names <- names(table)[which(!(names(table)%in%pmr0.cols))]
pmr0.excess <- table[, c("apid","rowi","coli",pmr0.excess.names), with = FALSE]
