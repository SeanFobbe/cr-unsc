#' f.record_metadata
#'
#' Extract all relevant metadata from a UN Digital Library record page.
#'
#' @param x String. A valid URL or filename for a UN Digital Library record page.
#'
#' @return A data.table containing all relevant metadata for a single record page.




f.record_metadata <- function(x){


    tryCatch({
        
        
        ## Read HTML
        html <- rvest::read_html(x)
        
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

            url_record_draft <- html_nodes(content.nodes[[draft.pos]], "a")
            url_record_draft <- html_attr(url_record_draft, "href")
            url_record_draft <- paste0(url_record_draft, collapse = "|")

            url_record_draft <- ifelse(grepl("record",
                                               url_record_draft),
                                         url_record_draft, NA_character_)
            



        }else if(length(draft.pos) == 0){

            url_record_draft <- NA_character_

        }else{

            url_record_draft <- "Error: More than one draft record position!"

        }

        
        ## Meeting Record
        meeting.pos <- grep("meeting", varname, ignore.case = TRUE)


        if(length(meeting.pos) == 1){

            url_record_meeting <- html_nodes(content.nodes[[meeting.pos]], "a")
            url_record_meeting <- html_attr(url_record_meeting, "href")
            url_record_meeting <- paste0(url_record_meeting, collapse = "|")

            url_record_meeting <- ifelse(grepl("\\/record\\/",
                                               url_record_meeting),
                                         url_record_meeting, NA_character_)
            




        }else if(length(meeting.pos) == 0){

            url_record_meeting <- NA_character_

        }else{

            url_record_meeting <- "Error: More than one meeting record position!"

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


        ## Doc ID
        dt.meta$doc_id <- gsub("\\/|\\(", "_", dt.meta$symbol)
        dt.meta$doc_id <- gsub("\\)| ", "", dt.meta$doc_id)

        ## Acquire URLs
        dt.pdf <- f.record_url(x,
                               prefix = "url_res_")

        ## Finalize
        dt.final <- cbind(dt.meta, dt.pdf)

        
        return(dt.final)

    },
    error = function(cond) {
        return(NA)}
    )
    
}
