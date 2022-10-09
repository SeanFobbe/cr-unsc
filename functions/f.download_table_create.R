

#' @param record.table Data.table. A table of UNSC resolution numbers and Digital Library record pages.
#' @param sleep Numeric. The number of seconds to sleep between requests.
#' @param debug Logical. Whether to download only a subet of resolutions.
#' @param debug.sample Integer. A vector of resolution numbers to download.




f.download_table_create <- function(record.table,
                                    sleep = runif(nrow(record.table), 1, 3),
                                    debug.toggle = FALSE,
                                    debug.sample = sample(2500, 50)){


    if(debug.toggle == TRUE){

        record.table <- record.table[res_no %in% sort(debug.sample)]

    }
    
    metadata.list <- lapply(X = record.table$url_record,
                            FUN = f.record_metadata,                       
                            sleep = sleep,
                            verbose = TRUE)
    

    metadata.dt <- rbindlist(metadata.list, fill = TRUE)


    dt.final <- cbind(record.table, metadata.dt)

    
    return(dt.final)


}
