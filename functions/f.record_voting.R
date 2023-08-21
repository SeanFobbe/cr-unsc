#' Build a table of record pages for UN Security Council resolutions sourced from the UN Digital Library.

#' @param recordtable.stable Data.Table. A stable download table of UN Digital Library pages for UNSC resolution voting data included in the source code.
#' @param limit Integer. Query the database up to which resolution?
#' @param debug.toggle Logical. Whether to only download a randomized subset of resolutions.
#' @param debug.sample Integer. The number of random resolutions to return in debugging mode.
#' 
#' 
#' @return The final updated download table with all resolutions specified.



f.record_voting <- function(recordtable.stable,
                           limit,
                           debug.toggle = TRUE,
                           debug.sample = 50){





}









#' For a given UN Security Council resolution, extract the relevant voting data page in the UN Digital Library.

#' @param resno The number of a UN Security Council resolution.
#'
#' @return The absolute link to a USNC resolution voting data page in the UN Digital Library.



f.extract_record <- function(resno){

    query <- paste0("https://digitallibrary.un.org/search?ln=en&as=1&cc=Voting+Data&m1=a&p1=S%2FRES%2F",
                    resno,                    "&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&action_search=Search&sf=&so=d&rg=50&c=Voting+Data&c=&of=hb&fti=0&fti=0")

    links <- f.linkextract(query)
    record <- unique(grep("/record/[0-9]+", links, value = TRUE))

    
    ## if(length(record) == 0){
        
    ##     query <- paste0("https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F",
    ##                     resno,                        "+(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&sf=&so=d&rg=50&c=United%20Nations%20Digital%20Library%20System&of=hb&fti=0&fti=0&fct__1=Resolutions%20and%20Decisions")

    ##     links <- f.linkextract(query)
    ##     record <- unique(grep("/record/[0-9]+$", links, value = TRUE))
        
    ## }
    

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





    
