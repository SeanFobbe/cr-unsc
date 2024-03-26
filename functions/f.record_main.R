#' Build a table of record pages for UN Security Council resolutions sourced from the UN Digital Library.

#' @param record.table.stable Data.Table. A stable download table of UN Digital Library pages for UNSC resolutions included in the source code.
#' @param res.no.full Integer. The complete set of resolution numbers to be queried. Reducing this set for debugging purposes must take place in an upstream target.
#' 
#' 
#' @return The final updated download table with all resolutions specified.



f.record_main <- function(record.table.stable = NA,
                          res.no.full){

    
    if (any(class(record.table.stable) %in% "data.frame")){

        res_no_work <- setdiff(res.no.full,
                               record.table.stable$res_no)
        
    }else{

        res_no_work  <- res.no.full
        
    }
    

    if (length(res_no_work) != 0){

        ## Extract records
        url.record.list <- lapply(res_no_work, f.extract_record_main)

        ## Replace empty elements with NA
        url.record.list2 <- lapply(url.record.list, f.list.empty.NA)

        ## Unlist
        url.record <- unlist(url.record.list2)

        ## Make table
        recordtable.new <- data.table(res_no = res_no_work,
                                      url_record = url.record)

        ## Remove rows with NA
        recordtable.new <- recordtable.new[!url_record == "NA"]

        ## Finalize

        if (any(class(record.table.stable) %in% "data.frame")){
            
            recordtable.final <- rbind(record.table.stable, recordtable.new)[order(res_no)]

        }else{

            recordtable.final  <- recordtable.new[order(res_no)]
            
        }
        

    }else{

        recordtable.final <- record.table.stable
        
    }


    ## Align with target resolution numbers (relevant in debugging mode)
    recordtable.final <- recordtable.final[res_no %in% res.no.full][order(res_no)]
    


    return(recordtable.final)
    
    
}





#' For a given UN Security Council resolution, extract the relevant main page in the UN Digital Library.

#' @param resno The number of a UN Security Council resolution.
#'
#' @return The absolute link to a USNC resolution main page in the UN Digital Library.



f.extract_record_main <- function(resno){

    ## Query without space, e.g. S/RES/988(
    query <- paste0("https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F",
                    resno,                     "(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&sf=&so=d&rg=50&c=United%20Nations%20Digital%20Library%20System&of=hb&fti=0&fti=0&fct__1=Resolutions%20and%20Decisions")

    links <- f.linkextract(query)
    record <- unique(grep("/record/[0-9]+$", links, value = TRUE))


    ## Query with space, e.g. S/RES/988 (
    if(length(record) == 0){
        
        query <- paste0("https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F",
                        resno,                        "+(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&sf=&so=d&rg=50&c=United%20Nations%20Digital%20Library%20System&of=hb&fti=0&fti=0&fct__1=Resolutions%20and%20Decisions")

        links <- f.linkextract(query)
        record <- unique(grep("/record/[0-9]+$", links, value = TRUE))
        
    }
    


    Sys.sleep(runif(1, 2, 3))
    
    message(resno)


    
    if(length(record) == 0){

        message(paste("No link acquired for", resno))
        
        return(NA)
        
    }else{

        record.absolute <- paste0("https://digitallibrary.un.org",
                                  record)

        return(record.absolute)
        
    }

    
    
}


## DEBUGGING CODE

## tar_load(record.table.stable)
## tar_load(res.no.full)
