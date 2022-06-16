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


resno <- 55

"https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F55(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&sf=&so=d&rg=50&c=United%20Nations%20Digital%20Library%20System&of=hb&fti=0&fti=0&fct__1=Resolutions%20and%20Decisions"


extract_metalink <- function(resno){

    query <-     paste0("https://digitallibrary.un.org/search?ln=en&as=1&m1=p&p1=S%2FRES%2F",
                        resno,
                        "(&f1=documentsymbol&op1=a&m2=a&p2=&f2=&op2=a&m3=a&p3=&f3=&dt=&d1d=&d1m=&d1y=&d2d=&d2m=&d2y=&rm=&ln=en&sf=&so=d&rg=50&c=United%20Nations%20Digital%20Library%20System&of=hb&fti=0&fti=0&fct__1=Resolutions%20and%20Decisions")

    links <- f.linkextract(query)
    record <- unique(grep("/record/[0-9]+$", links, value = TRUE))

    Sys.sleep(runif(1, 1, 2))
    message(resno)

    return(record)
    
    
}


tictoc::tic()
res_nos <- 1:2636

recordlinks <- lapply(res_nos, extract_metalink)


tictoc::toc()


library(data.table)

f.list.empty.NA <- function(x) if (length(x) == 0) NA_character_ else paste(x, collapse = " ")


recordlinks2 <- lapply(recordlinks, f.list.empty.NA)


recordlinks.vec <- unlist(recordlinks2)

recordlinks_url <- paste0("https://digitallibrary.un.org",
                          recordlinks.vec)

recordlinks_url[grepl("NA", recordlinks_url)] <- NA


download.table <- data.table(res_nos, recordlinks_url)

fwrite(download.table, "UNSC_Record-Pages.csv")


data.table(res_nos, recordlinks_url)[sample(50, 5)]




url <- "https://digitallibrary.un.org/record/111952" # res 37

html <- read_html(url)

# add: lik to draft res and meeting record

extract_download_undl <- function(html){

    # sample link:  "/record/111952/files/S_RES_37%281947%29-ES.pdf"
    
    links <- html_nodes(html, "a") %>% html_attr('href')

    pdf.relative <- unique(grep("/record/[0-9]+/files", links, value = TRUE))

    pdf.absolute <- paste0("https://digitallibrary.un.org",
                                pdf.relative)

    pdf.ar <- grep("AR\\.pdf", pdf.absolute, value = TRUE)
    pdf.en <- grep("EN\\.pdf", pdf.absolute, value = TRUE)
    pdf.es <- grep("ES\\.pdf", pdf.absolute, value = TRUE)
    pdf.fr <- grep("FR\\.pdf", pdf.absolute, value = TRUE)
    pdf.ru <- grep("RU\\.pdf", pdf.absolute, value = TRUE)
    pdf.zh <- grep("ZH\\.pdf", pdf.absolute, value = TRUE)


    value <- data.table(pdf.ar,
                        pdf.en,
                        pdf.es,
                        pdf.fr,
                        pdf.ru,
                        pdf.zh)
    
    return(value)
    
    }


extract_meta_undl <- function(html){

    nodes <- html_nodes(html, "[class='metadata-row']")
    title <- html_nodes(html, "[class='title col-xs-12 col-sm-3 col-md-2']") %>% html_text()
    title <- trimws(title)
    title <- gsub(" ", "_", title)
    content <- html_nodes(html, "[class='value col-xs-12 col-sm-9 col-md-10']") %>% html_text()
    content <- trimws(content)

    value <- data.table(title, content)
    value <- transpose(value, make.names = "title")

    pdf <- extract_download_undl(html)
    
    value <- cbind(value, pdf)
    
    return(value)
    
    }



extract_meta_undl(html)


fwrite(value, "test.csv")




