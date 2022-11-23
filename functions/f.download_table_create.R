#' Create a preliminary download table from the record pages in the UN Digital Library.


#' @param x String. A vector of filenames to UN Digital Libary record pages for UNSC resolutions.



## produces duplicates, 2644 instead of 2640 rows. see below
## url.meeting and url.draft have duplicates


# duplicates:

## 1: S_RES_0001_1946
## 2: S_RES_0100_1953
## 3: S_RES_1000_1995
## 4: S_RES_1001_1995


## dt.record <- tar_read(dt.record.final)
## tar_load(dt.download)
## tar_load(url.meeting)
## tar_load(url.draft)


f.download_table_finalize <- function(dt.download,
                                      dt.record,
                                      url.meeting,
                                      url.draft){


    ## Remove duplicates (temp fix, must check url creation funcs)
    url.meeting <- url.meeting[duplicated(url.meeting$res_no)]
    url.draft <- url.draft[duplicated(url.draft$res_no)]


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
