#' f.record_metadata
#'
#' Extract all relevant metadata from a UN Digital Library record page.
#'
#' @param url A valid URL for a UN Digital Library record page.
#' @param sleep The time in seconds to sleep between requests. Defaults to random number between 1 and 2.
#'
#' @return A data.table containing all relevant metadata for a single record page.


# testing url <- "https://digitallibrary.un.org/record/111952" # res 37



f.record_metadata <- function(url,
                              sleep = rnorm(1, 1, 2)){

    ## Read HTML
    html <- rvest::read_html(url)
    
    ## Nodes
    nodes <- rvest::html_nodes(html, "[class='metadata-row']")

    ## Variable names
    varname <- rvest::html_nodes(html, "[class='title col-xs-12 col-sm-3 col-md-2']") %>% html_text()
    varname <- trimws(varname)
    varname <- gsub(" ", "_", varname)
    varname <- tolower(varname)

    ## Variable content
    content.nodes <- rvest::html_nodes(html, "[class='value col-xs-12 col-sm-9 col-md-10']")
    content.text <- html_text2(content.nodes)
    content.text <- trimws(content.text)

    ## Draft
    draft.pos <- grep("draft", varname, ignore.case = TRUE)

    if(length(draft.pos) == 1){

        url_record_draft <- html_nodes(content.nodes[[draft.pos]], "a") %>% html_attr("href")

    }else if(length(draft.pos) == 0){

        url_record_draft <- NA_character_

    }else{

        url_record_draft <- "Error: More than one draft record found!"

    }

    
    ## Meeting Record
    meeting.pos <- grep("meeting", varname, ignore.case = TRUE)


    if(length(meeting.pos) == 1){

        url_record_meeting <- html_nodes(content.nodes[[meeting.pos]], "a") %>% html_attr("href")

    }else if(length(meeting.pos) == 0){

        url_record_meeting <- NA_character_

    }else{

        url_record_meeting <- "Error: More than one meeting record found!"

    }

    
    ## Subjects
    subjects <- rvest::html_nodes(html, "[class='metadata-row rs-list-row-inner']") %>% html_text()
    subjects <- gsub("\n", "", subjects)
    subjects <- trimws(subjects)
    subjects <- gsub(" {2,}", " > ", subjects)
    subjects <- paste0(subjects, collapse = "|")

    ## Create table
    dt.meta <- data.table(varname, content.text)
    dt.meta <- transpose(dt.meta, make.names = "varname")
    
    dt.meta <- cbind(dt.meta,
                     subjects,
                     url_record_draft,
                     url_record_meeting)

    ## Acquire URLs
    dt.pdf <- f.record_extract_url(html)

    ## Finalize
    dt.final <- cbind(dt.meta, dt.pdf)
    
    return(dt.final)
    
}



#' f.record_extract_url
#'
#' Extract all URLs to the texts of a given document from a UN Digital Library record page.
#'
#' @param html A UN Digital Library record page in HTML format.
#'
#' @return A data.table of all URLs to texts in each UN language.



f.record_extract_url <- function(html){

    ## sample link:  "/record/111952/files/S_RES_37%281947%29-ES.pdf"
    
    links <- rvest::html_nodes(html, "a") %>% html_attr('href')

    pdf.relative <- unique(grep("/record/[0-9]+/files", links, value = TRUE))

    pdf.absolute <- paste0("https://digitallibrary.un.org",
                           pdf.relative)

    url_text_ar <- f.grep.NA("AR\\.pdf", pdf.absolute)    
    url_text_en <- f.grep.NA("EN\\.pdf", pdf.absolute)
    url_text_es <- f.grep.NA("ES\\.pdf", pdf.absolute)
    url_text_fr <- f.grep.NA("FR\\.pdf", pdf.absolute)
    url_text_ru <- f.grep.NA("RU\\.pdf", pdf.absolute)
    url_text_zh <- f.grep.NA("ZH\\.pdf", pdf.absolute)


    dt.final <- data.table(url_text_ar,
                           url_text_en,
                           url_text_es,
                           url_text_fr,
                           url_text_ru,
                           url_text_zh)
    
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
