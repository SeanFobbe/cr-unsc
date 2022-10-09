#+
#'## f.linkextract: Extract Links from HTML
#' This function extracts all links (i.e. href attributes of <a> tags) from an arbitrary HTML document. Returns "NA" if there is an error.
#'

#' @param URL A valid URL.

#library(rvest)

f.linkextract <- function(URL){
    tryCatch({
        read_html(URL) %>%
            html_nodes("a")%>%
            html_attr('href')},
        error = function(cond) {
            return(NA)}
        )
}


library(rvest)


resno <- 2600

# example query
"https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F55(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&sf=&so=d&rg=50&c=United%20Nations%20Digital%20Library%20System&of=hb&fti=0&fti=0&fct__1=Resolutions%20and%20Decisions"


extract_metalink <- function(resno){

    query <-     paste0("https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F",
                        resno,
                        "(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&sf=&so=d&rg=50&c=United%20Nations%20Digital%20Library%20System&of=hb&fti=0&fti=0&fct__1=Resolutions%20and%20Decisions")

    links <- f.linkextract(query)
    record <- unique(grep("/record/[0-9]+$", links, value = TRUE))

    if(length(record) == 0){
        
        query <-     paste0("https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F",
                            resno,
                            "+(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&sf=&so=d&rg=50&c=United%20Nations%20Digital%20Library%20System&of=hb&fti=0&fti=0&fct__1=Resolutions%20and%20Decisions")

        links <- f.linkextract(query)
        record <- unique(grep("/record/[0-9]+$", links, value = TRUE))
        
    }

    if(length(record) == 0){

        message(paste("No link acquired for", resno))
        
    }

    Sys.sleep(runif(1, 1, 2))
    
    message(resno)

    return(record)
    
    
}

"https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F2600(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&sf=&so=d&rg=50&c=United%20Nations%20Digital%20Library%20System&of=hb&fti=0&fti=0&fct__1=Resolutions%20and%20Decisions"

"https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F2600%28&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&action_search=Search&sf=&so=d&rg=50&c=United+Nations+Digital+Library+System&of=hb&fti=0&fti=0"




library(data.table)

res_nos_full <- 1:2636

maintable <- fread("data/UNSC_Record-Pages_2636.csv")

res_nos_work <- setdiff(res_nos_full, maintable$res_nos)


tictoc::tic()

recordlinks <- lapply(res_nos, extract_metalink)

tictoc::toc()

f.list.empty.NA <- function(x) if (length(x) == 0) NA_character_ else paste(x, collapse = " ")
recordlinks2 <- lapply(recordlinks, f.list.empty.NA)

recordlinks.vec <- unlist(recordlinks2)

recordlinks_url <- paste0("https://digitallibrary.un.org",
                          recordlinks.vec)

recordlinks_url[grepl("NA", recordlinks_url)] <- NA
download.table <- data.table(res_nos, recordlinks_url)


download.table.content <- download.table[!is.na(recordlinks_url)]


download.table.result <- rbind(maintable, download.table.content)[order(res_nos)]



fwrite(download.table.result, "UNSC_Record-Pages_automatic.csv", na = "NA")













