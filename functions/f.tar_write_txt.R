#' f.tar_write_txt
#'
#' Write data from data.frame text vector to TXT files.
#'
#' @param text String. A vector containing texts.
#' @param doc_id String. A vector of file names corresponding to the tets.
#' @param dir String. The directory the TXT files are written to.
#' @param cleandir Logical. Whether to clear the directory before writing to it. Defaults to FALSE.

#' @return String. An (invisible) vector of output filenames. Compatible with {targets} pipelines.



f.tar_write_txt <- function(text,
                            doc_id,
                            dir = "txt",
                            cleandir = FALSE){

    if (cleandir = TRUE){

        unlink(dir, recursive = TRUE)
        
    }

    dir.create(dir, showWarnings = FALSE)

    file <- file.path(dir, doc_id)

    result <- mapply(utils::write.table,
                     x = text,
                     file = file,
                     quote = FALSE,
                     row.names = FALSE,
                     col.names = FALSE)


    files <- list.files(dir, full.names = TRUE)


    invisible(files)
    

}


## DEBUGGING CODE

## dir <- "files/txt_res_en_best"
## tar_load(dt.final)
## text <- dt.final$text
## doc_id <- dt.final$doc_id




## ## Write TXT to Disk
## utils::write.table(pdf.extracted,
##                    txtname,
##                    quote = FALSE,
##                    row.names = FALSE,
##                    col.names = FALSE)

