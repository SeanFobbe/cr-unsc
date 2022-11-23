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


    ## Unit Tests
    
    test_that("Argument classes satisfy expectations.", {
        expect_s3_class(dt.download, "data.table")
        expect_s3_class(dt.record, "data.table")
        expect_s3_class(url.meeting, "data.table")
        expect_s3_class(url.draft, "data.table")

    })

    test_that("Argument row counts satisfy expectations.", {
        expect_equal(dt.record[,.N], dt.download[,.N])
        expect_gte(dt.record[,.N], url.meeting[,.N])
        expect_gte(dt.record[,.N], url.draft[,.N])

    })
    

    ## Remove meeting duplicates (temp fix, must check url creation funcs)

    remove <- grep("S_PV.3544-EN", url.meeting$url_meeting_en)

    if(length(remove) > 0){
        url.meeting <- url.meeting[-remove]
    }

    ## Remove draft duplicates (temp fix, must check url creation funcs)
    
    remove <- grep("S_1995_465-EN|S_1995_478-EN|S_1995_486-EN", url.draft$url_draft_en)

    if(length(remove) > 0){
    url.draft <- url.draft[-remove]
    }


    ## Unit Test 
    test_that("Arguments do not contain duplicate resolution numbers.", {
        expect_equal(sum(duplicated(dt.record$res_no)), 0)
        expect_equal(sum(duplicated(dt.download$res_no)), 0)
        expect_equal(sum(duplicated(url.meeting$res_no)), 0)
        expect_equal(sum(duplicated(url.draft$res_no)), 0)
    })


    

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


    ## Unit Test 
    test_that("Result satisfies expectations.", {
        expect_s3_class(dt, "data.table")
        expect_equal(sum(duplicated(dt)), 0)
        expect_equal(dt.record[,.N], dt[,.N])
    })    
    
    
    return(dt)


}
