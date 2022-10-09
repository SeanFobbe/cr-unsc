#' Build a table of record pages for UN Security Council resolutions sourceddrawn from the UN Digital Library.

#' @param record.table A raw download table of UN Digital Library pages for UNSC resolutions included in the source code.
#' @param limit Query the database up to which resolution?
#' 
#'
#' @return The final updated download table with all resolutions specified.


## needs more work



f.record_table <- function(record.table,
                                  limit){

    ## Define Scope
    res_nos_full <- 1:limit

    res_nos_work <- setdiff(res_nos_full,
                            record.table$res_nos)

    if (length(res_nos_work) != 0){

        ## Slowest part of function, ca. 1.5 sec per resolution
        recordlinks <- lapply(res_nos_work, f.extract_record)

        recordlinks2 <- lapply(recordlinks, f.list.empty.NA)

        recordlinks.vec <- unlist(recordlinks2)

        record.table <- data.table(res_nos_work, recordlinks.vec)

        record.table.content <- record.table[!is.na(recordlinks_url)]



        record.table.result <- rbind(record.table, record.table.content)[order(res_nos)]

    }else{

        return(record.table)
        
    }

    
}





#' For a given UN Security Council resolution, extract the relevant page in the UN Digital Library.

#' @param resno The number of a UN Security Council resolution.
#'
#' @return The absolute link to a USNC resolution page in the UN Digital Library.


f.extract_record <- function(resno){

    query <- paste0("https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F",
                    resno,                     "(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&sf=&so=d&rg=50&c=United%20Nations%20Digital%20Library%20System&of=hb&fti=0&fti=0&fct__1=Resolutions%20and%20Decisions")

    links <- f.linkextract(query)
    record <- unique(grep("/record/[0-9]+$", links, value = TRUE))

    if(length(record) == 0){
        
        query <- paste0("https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F",
                        resno,                        "+(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&sf=&so=d&rg=50&c=United%20Nations%20Digital%20Library%20System&of=hb&fti=0&fti=0&fct__1=Resolutions%20and%20Decisions")

        links <- f.linkextract(query)
        record <- unique(grep("/record/[0-9]+$", links, value = TRUE))
        
    }
    

    if(length(record) == 0){

        message(paste("No link acquired for", resno))
        
        return(NA)
        
    }else{

        record.absolute <- paste0("https://digitallibrary.un.org",
                                  record)

        return(record.absolute)
        
    }

    Sys.sleep(runif(1, 1, 2))
    
    message(resno)


    
    
}
