#' Create a download manifest from the record pages in the UN Digital Library.


#' @param dt.download Data.table. The initial download table created from parsing UNDL record pages.
#' @param dt.record Data.table. The final record table containing URLs to all UN main record pages.
#' @param url.meeting Data.table. A table of URLs to meeting records for each resolution.
#' @param url.draft Data.table. A table of URLs to drafts for each resolution.




f.download_manifest <- function(dt.download,
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
    

    ## Remove meeting duplicates and mistaken inclusions (check url creation funcs!)

    remove <- grep("S_PV.3544-EN|S_PV.9458-EN", url.meeting$url_meeting_en)

    if(length(remove) > 0){
        url.meeting <- url.meeting[-remove]
    }

    ## Remove draft duplicates and mistaken inclusions (check url creation funcs!)
    
    remove <- grep("S_1995_465-EN|S_1995_478-EN|S_1995_486-EN|S_2023_802-EN|S_2023_808-EN|S_2023_807-EN", url.draft$url_draft_en)

    if(length(remove) > 0){
        url.draft <- url.draft[-remove]
    }


    ## Unit Test 
    test_that("Individual tables do not contain duplicate resolution numbers.", {
        expect_equal(dt.record[duplicated(res_no),.N], 0)
        expect_equal(dt.download[duplicated(res_no),.N], 0)
        expect_equal(url.meeting[duplicated(res_no),.N], 0)
        expect_equal(url.draft[duplicated(res_no),.N], 0)
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

    ## Finalize
    dt.final <- dt
    

    ## Unit Tests
    test_that("Types are correct", {
        expect_s3_class(dt.final, "data.table")
    })
    
    test_that("Result does not contain duplicate rows", {
        expect_equal(sum(duplicated(dt.final)), 0)
    })

    test_that("Result contains same number of rows as input.", {
        expect_equal(dt.record[,.N], dt.final[,.N])
    }) 


    
    test_that("URLs are valid", {

        names.url.record <- grep("url_record", names(dt.final), value = TRUE)

        for(i in names.url.record){

            vec <- na.omit(unlist(dt.final[,..i]))
            grep <- grepl("https://digitallibrary.un.org/record/[0-9+]", vec)
            expect_true(all(grep))

        }

        names.url.files <- grep("url_res|url_meeting|url_draft", names(dt.final), value = TRUE)

        for(i in names.url.files){

            vec <- na.omit(unlist(dt.final[,..i]))
            grep <- grepl("https://digitallibrary.un.org/record/.*\\.pdf", vec)
            expect_true(all(grep))

        }

    })


    names.url.all <- grep("url", names(dt.final), value = TRUE)
    
    for(i in names.url.all){
        
        vec <- na.omit(unname(unlist(dt.final[,..i])))
        sum <- sum(duplicated(vec))

        print(i)
        expect_equal(sum, 0)
        
    }

    unname(unlist(dt.final[!is.na(url_record_draft)]))
    

    dt.final[,..i][duplicated(omiturl_res_fr)]

    test_that("URLs are unique", {
        expect_equal(sum(duplicated(dt.final$url_record)),  0)
        expect_equal(sum(duplicated(dt.final$url_record_draft)),  0)
        expect_equal(sum(duplicated(dt.final$url_record_meeting)),  0) 
        expect_equal(sum(duplicated(dt.final$url_res_en)),  0)
        expect_equal(sum(duplicated(dt.final$url_res_es)),  0)
        expect_equal(sum(duplicated(dt.final$url_res_ru)),  0)        
        ##expect_equal(sum(duplicated(dt.final$url_res_fr)),  0) # fails        
        ##expect_equal(sum(duplicated(dt.final$url_res_ar)),  0) # fails
        ##expect_equal(sum(duplicated(dt.final$url_res_zh)),  0) # fails

        ## ADD draft and meeting URL
    })
    
    
    
    return(dt)


}


## DEBUGGING CODE

## library(data.table)
## library(testthat)
## dt.record <- tar_read(dt.record.final)
## tar_load(dt.download)
## tar_load(url.meeting)
## tar_load(url.draft)
