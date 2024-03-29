#' upload_DNT60
#'
#' Upload Padilla DNT60 Behavior Data from "All Chemicals on per sheet.xlsx"
#'
#' @author Zachary Rowson \email{Rowson.Zachary@@epa.gov}
#'
#' @details
#' Returns complete USA EPA ORD CCTE BCTD RADB Padilla lab DNT60 behavior data
#' set in pmr0 format. pmr0 format is easily transformed
#' into mc0 with gabi::as_mc0() for tcpl analysis.
#'
#' Last edit: 09/24/2021
#'
#' @param path path to Excel file "All Chemicals one per sheet.xlsx"
#'
#' @return A pmr0 format data.table of all test animals described in "All Chemicals one per sheet.xlsx".
#'   Returned table will contain the following variables.
#'   \itemize{
#'     \item srcf - name of file that is being formatted
#'     \item acid - assay component id (Here ZFpmrALD-20-40-40)
#'       Zebrafish photomotor resonse, AccilmationLightDark-20 minutes-40 minutes-40 minutes
#'     \item cpid - chemical name
#'     \item apid - assay plate id, DNT###
#'     \item rowi - row on plate
#'     \item coli - column on plate
#'     \item wllt - well type according to tcpl mc0 format
#'      t = test, v = vehicle control
#'     \item wllq - well quality indicates if observation is viable for analysis
#'       1 = yes, 0 = no
#'     \item conc - concentration of chemical
#'     \item tj - measurements of total distance moved at 2 minute time period j for j /in {1,2,...,n}
#'       Here n = 50
#'   }
#'
#'   @import data.table

upload_DNT60 <- function(path) { # This function prints warnings from data.table. Figure out why and fix it
                    sheetnames <- readxl::excel_sheets(path)
                    names(sheetnames) <- sheetnames
                  # Upload all sheets from .xlsx file as data.tables
                    tables <- lapply(sheetnames,
                                     function(sheet) {
                                       data.table::as.data.table(readxl::read_excel(path, sheet = sheet))
                                     }
                    )
                  # Format tables according to pmr0 format
                    tbls_pmr0 <- lapply(tables, function(table) as_pmr0(table, file.name = "All Chemicals one per sheet.xlsx"))
                  # Create one large table of all chemicals via row binding and remove duplicate controls
                    pmr0 <- data.table::rbindlist(tbls_pmr0, use.names = TRUE) %>%
                              unique()

                  return(pmr0)
                }
