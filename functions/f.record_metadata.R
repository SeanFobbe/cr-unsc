





url <- "https://digitallibrary.un.org/record/111952" # res 37

html <- read_html(url)

# add: lik to draft res and meeting record



f.record_metadata <- function(html){

    ## Nodes
    nodes <- html_nodes(html, "[class='metadata-row']")

    ## Variable names
    varname <- html_nodes(html, "[class='title col-xs-12 col-sm-3 col-md-2']") %>% html_text()
    varname <- trimws(varname)
    varname <- gsub(" ", "_", varname)
    varname <- tolower(varname)

    ## Variable content
    content <- html_nodes(html, "[class='value col-xs-12 col-sm-9 col-md-10']") %>% html_text()
    content <- trimws(content)

    ## Subjects
    subjects <- html_nodes(html, "[class='metadata-row rs-list-row-inner']") %>% html_text()
    subjects <- gsub("\n", "", subjects)
    subjects <- trimws(subjects)
    subjects <- gsub(" {2,}", " > ", subjects)
    subjects <- paste0(subjects, collapse = "|")

    ## Create table
    dt.meta <- data.table(varname, content)
    dt.meta <- transpose(dt.meta, make.names = "varname")
    dt.meta <- cbind(dt.meta, subjects)

    ## Acquire URLs
    dt.pdf <- f.record_extract_url(html)

    ## Finalize
    dt.final <- cbind(dt.meta, dt.pdf)
    
    return(dt.final)
    
}






f.record_extract_url <- function(html){

    ## sample link:  "/record/111952/files/S_RES_37%281947%29-ES.pdf"
    
    links <- html_nodes(html, "a") %>% html_attr('href')

    pdf.relative <- unique(grep("/record/[0-9]+/files", links, value = TRUE))

    pdf.absolute <- paste0("https://digitallibrary.un.org",
                           pdf.relative)

    pdf.ar <- f.grep.NA("AR\\.pdf", pdf.absolute)    
    pdf.en <- f.grep.NA("EN\\.pdf", pdf.absolute)
    pdf.es <- f.grep.NA("ES\\.pdf", pdf.absolute)
    pdf.fr <- f.grep.NA("FR\\.pdf", pdf.absolute)
    pdf.ru <- f.grep.NA("RU\\.pdf", pdf.absolute)
    pdf.zh <- f.grep.NA("ZH\\.pdf", pdf.absolute)


    dt.final <- data.table(pdf.ar,
                           pdf.en,
                           pdf.es,
                           pdf.fr,
                           pdf.ru,
                           pdf.zh)
    
    return(dt.final)
    
}




#' f.grep.NA
#'
#' Search for string, return value. If no value is found, return NA. Arguments as with classic grep.


f.grep.NA <- function(pattern, x){

    value <- grep(pattern = pattern, x = x, value = TRUE)

    if (length(value) == 0){

        value <- NA_character_
        
    }

    return(value)

}
