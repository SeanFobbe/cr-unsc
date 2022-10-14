

#' @param record.table Data.table. A table of UNSC resolution numbers and Digital Library record pages.
#' @param sleep Numeric. The number of seconds to sleep between requests.
#' @param debug Logical. Whether to download only a subet of resolutions.
#' @param debug.sample Integer. A vector of resolution numbers to download.




f.download_table_create <- function(record.table,
                                    sleep = abs(rgamma(nrow(record.table), 2, 1)),
                                    debug.toggle = FALSE,
                                    debug.sample = sample(2500, 50)){


    if(debug.toggle == TRUE){

        record.table <- record.table[res_no %in% sort(debug.sample)]

    }
    

    ## First Pass
    tictoc::tic()

    metadata.list <- vector("list", nrow(record.table))

    for(i in 1:nrow(record.table)){

        message(i)

        metadata.list[[i]] <- f.record_metadata(url = record.table$url_record[i],
                                                sleep = sleep,
                                                verbose = TRUE)

        if ((i %% 500) == 0){

            Sys.sleep(180)
            
        }

        
    }

    tictoc::toc()


    ## Retry

    for(i in which(is.na(metadata.list))){

        metadata.list[[i]] <- f.record_metadata(url = record.table$url_record[i],
                                                sleep = 5,
                                                verbose = TRUE)
        
    }

    

    metadata.dt <- rbindlist(metadata.list, fill = TRUE)


    dt.final <- cbind(record.table, metadata.dt)

    
    return(dt.final)


}
