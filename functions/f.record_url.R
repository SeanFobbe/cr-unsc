#' f.record_url
#'
#' Extract all URLs to the full texts for a given document from a UN Digital Library record page.
#'
#' @param html A UN Digital Library record page in HTML format.
#'
#' @return A data.table of all URLs to texts in each UN language.



## sample link:  "/record/111952/files/S_RES_37%281947%29-ES.pdf"

# add: where link does not contain the string "record", replace with NA


f.record_url <- function(x,
                         prefix = ""){



    ## Read HTML
    html <- rvest::read_html(x)
    
    links <- rvest::html_nodes(html, "a") %>% html_attr('href')

    pdf.relative <- unique(grep("/record/[0-9]+/files", links, value = TRUE))

    ## Fix for rare bug (3 cases in drafts, 1 in meeting record, where both absolute and relative URL are present)
    pdf.relative <- grep("https://", pdf.relative, value = TRUE, invert = TRUE)

    pdf.absolute <- paste0("https://digitallibrary.un.org",
                           pdf.relative)

    ar <- f.grep.NA("AR\\.pdf", pdf.absolute)    
    en <- f.grep.NA("EN\\.pdf", pdf.absolute)
    es <- f.grep.NA("ES\\.pdf", pdf.absolute)
    fr <- f.grep.NA("FR\\.pdf", pdf.absolute)
    ru <- f.grep.NA("RU\\.pdf", pdf.absolute)
    zh <- f.grep.NA("ZH\\.pdf", pdf.absolute)


    dt.final <- data.table(ar,
                           en,
                           es,
                           fr,
                           ru,
                           zh)

    setnames(dt.final,
             new = paste0(prefix, names(dt.final)))
    
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
