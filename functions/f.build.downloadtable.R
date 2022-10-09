#' Build a download table for UN Security Council resolutions drawn from the UN Digital Library.



#' @param download.table A raw download table of UN Digital Library pages for UNSC resolutions included in the source code.
#' @param limit Query the database up to which resolution?
#' 
#'
#' @return The final updated download table with all resolutions specified.


## needs more work



f.build.downloadtable <- function(download.table,
                                  limit){

    ## Define Scope
    res_nos_full <- 1:limit

    res_nos_work <- setdiff(res_nos_full,
                            download.table$res_nos)

    if (length(res_nos_work) != 0){

        ## Slowest part of function, ca. 1.5 sec per resolution
        recordlinks <- lapply(res_nos_work, f.extract_metalink)

        recordlinks2 <- lapply(recordlinks, f.list.empty.NA)

        recordlinks.vec <- unlist(recordlinks2)

        download.table <- data.table(res_nos_work, recordlinks.vec)

        download.table.content <- download.table[!is.na(recordlinks_url)]



        download.table.result <- rbind(download.table, download.table.content)[order(res_nos)]

    }else{

        return(download.table)
        
    }

    
}
