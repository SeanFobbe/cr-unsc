#' Create a preliminary download table from the record pages in the UN Digital Library.


#' @param x String. A vector of filenames to UN Digital Libary record pages for UNSC resolutions.





## dt.record <- tar_read(dt.record.final)
## dt.download <- tar_read(dt.download)
## url.meeting <- tar_read(url.meeting)
## url.draft <- tar_read(url.draft)


f.download_table_finalize <- function(dt.download,
                                      dt.record,
                                      url.meeting,
                                      url.draft){



    ## Merge tables
    dt <- merge(dt.record, dt.download, on = "res_no", all.x = TRUE)
    dt <- merge(dt, url.meeting, on = "res_no", all.x = TRUE)
    dt <- merge(dt, url.draft, on = "res_no", all.x = TRUE)

    ## Extract year
    dt$year <- as.integer(gsub(".*\\(([0-9]{4})\\).*", "\\1", dt$symbol))

    ## Create Doc ID
    dt$doc_id <- paste("S",
                       "RES",
                       formatC(dt$res_no, width = 4, flag = "0"),
                       dt$year,
                       sep = "_")

    
    
    return(dt)


}
