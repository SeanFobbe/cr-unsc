
#' @param x A raw download table included in the source code.
#' @param limit The limit up to which resolution to query the database.
#' 
#'
#' @return The final updated download table with all resolutions up to the specified one.


f.build.downloadtable <- function(x,
                                  limit){

    ## Define Scope
    res_nos_full <- 1:limit

    res_nos_work <- setdiff(res_nos_full,
                            x$res_nos)

    if (length(res_nos_work) != 0){

        ## Longest Part of Function, ca. 1.5 sec per resolution
        recordlinks <- lapply(res_nos_work, f.extract_metalink)

        recordlinks2 <- lapply(recordlinks, f.list.empty.NA)

        recordlinks.vec <- unlist(recordlinks2)

        download.table <- data.table(res_nos_work, recordlinks.vec)

        download.table.content <- download.table[!is.na(recordlinks_url)]



        download.table.result <- rbind(x, download.table.content)[order(res_nos)]

    }else{

        return(x)
        
        }

    
}
