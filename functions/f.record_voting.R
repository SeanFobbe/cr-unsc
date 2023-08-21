#' Build a table of record pages for UN Security Council resolutions sourced from the UN Digital Library.

#' @param recordtable.stable Data.Table. A stable download table of UN Digital Library pages for UNSC resolution voting data included in the source code.
#' @param limit Integer. Query the database up to which resolution?
#' @param debug.toggle Logical. Whether to only download a randomized subset of resolutions.
#' @param debug.nums Integer. A vector of fixed resolution numbers to query.
#' 
#' 
#' @return The final updated download table with all resolutions specified.



f.record_voting <- function(recordtable.stable = NA,
                            limit,
                            debug.toggle = TRUE,
                            debug.nums = sample(1:limit, 50)){

    ## Define Scope
    res_no_full <- 1:limit

    
    if (is.na(recordtable.stable) == FALSE){

        res_no_work <- setdiff(res_no_full,
                               recordtable.stable$res_no)
        
    }else{

        res_no_work  <- res_no_full
        
    }
    


    if (length(res_no_work) != 0){

        ## Extract records
        url.record.list <- lapply(res_no_work, f.extract_record)

        ## Replace empty elements with NA
        url.record.list2 <- lapply(url.record.list, f.list.empty.NA)

        ## Unlist
        url.record <- unlist(url.record.list2)

        ## Make table
        recordtable.new <- data.table(res_no = res_no_work,
                                      url_record = url.record)

        ## Remove rows with NA
        recordtable.new <- recordtable.new[!is.na(url_record)]

        ## Finalize

        if (is.na(recordtable.stable) == FALSE){
            
            recordtable.final <- rbind(recordtable.stable, recordtable.new)[order(res_no)]

        }else{

            recordtable.final  <- record.table.new[order(res_no)]
            
        }

    }else{

        recordtable.final <- recordtable.stable
        
    }


    
    if(debug.toggle == TRUE){


        recordtable.final <- recordtable.final[res_no %in% debug.nums][order(res_no)]
        
    }

    


    return(recordtable.final)
    
    
}






#' For a given UN Security Council resolution, extract the relevant voting data page in the UN Digital Library.

#' @param resno The number of a UN Security Council resolution.
#'
#' @return The absolute link to a USNC resolution voting data page in the UN Digital Library.




f.extract_record <- function(resno){

    ## Query without space, e.g. S/RES/988(
    query <- paste0("https://digitallibrary.un.org/search?ln=en&as=1&cc=Voting+Data&m1=p&p1=S%2FRES%2F",
                    resno,                    "(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&action_search=Search&sf=&so=d&rg=50&c=Voting+Data&c=&of=hb&fti=0&fti=0")

    links <- f.linkextract(query)
    record <- unique(grep("/record/[0-9]+", links, value = TRUE))


    ## Query with space, e.g. S/RES/988 (
    if(length(record) == 0){
        
    query <- paste0("https://digitallibrary.un.org/search?ln=en&as=1&cc=Voting+Data&m1=p&p1=S%2FRES%2F",
                    resno,                    "+(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&action_search=Search&sf=&so=d&rg=50&c=Voting+Data&c=&of=hb&fti=0&fti=0")

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





    
