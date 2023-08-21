#' f.record_metadata
#'
#' Extract all relevant voting metadata from a UN Digital Library record page.
#'
#' @param x String. A valid URL or filename for a UN Digital Library record page.
#'
#' @return A data.table containing all relevant voting metadata for a single record page.



f.record_metadata_voting <- function(x){

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

        
        ## Create table
        dt.meta <- data.table(varname, content.text)
        dt.meta <- transpose(dt.meta, make.names = "varname")


        ## Select variables
        dt.meta <- dt.meta[,.(resolution, vote_summary, vote_date, vote)]


        ## Add res_no
        
        dt.meta$res_no <- as.integer(gsub("S\\/RES\\/([0-9]+).*",
                                          "\\1",
                                          dt.meta$resolution))
        
        
        ## Extract individual counts
        dt.meta$vote_yes <- as.integer(gsub(".*Yes: ([0-9]*).*",
                                            "\\1",
                                            dt.meta$vote_summary))

        dt.meta$vote_no <- as.integer(gsub(".*No: ([0-9]*).*",
                                           "\\1",
                                           dt.meta$vote_summary))

        dt.meta$vote_abstention <- as.integer(gsub(".*Abstentions: ([0-9]*).*",
                                                   "\\1",
                                                   dt.meta$vote_summary))

        dt.meta$vote_nonvote <- as.integer(gsub(".*Non-Voting: ([0-9]*).*",
                                                "\\1",
                                                dt.meta$vote_summary))
        

        dt.meta$vote_total <- as.integer(gsub(".*Total voting membership: ([0-9]*).*",
                                              "\\1",
                                              dt.meta$vote_summary))

        setnames(dt.meta, "vote", "vote_detail")
        

        
        return(dt.meta)


        
    },
    error = function(cond) {
        return(NA)}
    )
    
}



## DEBUGGING

## all <- tar_read(html.record.voting)

## x <- all[999]

## f.record_metadata_voting(all[2400])
