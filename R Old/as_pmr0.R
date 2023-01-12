#' Format data as pmr0
#'   Zachary Rowson
#'   Rowson.Zachary at epa.gov
#'   Last edit: 09/24/2021

as_pmr0 <- function(data, file.name = NULL) {
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
                srcf <- file.name
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
