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

    ## Add missing PDF URLs

    dt[1312]$url_res_ar <- "https://digitallibrary.un.org/record/419692/files/S_RES_1312%282000%29-AR.pdf"
    dt[1312]$url_res_en <- "https://digitallibrary.un.org/record/419692/files/S_RES_1312%282000%29-EN.pdf"
    dt[1312]$url_res_es <- "https://digitallibrary.un.org/record/419692/files/S_RES_1312%282000%29-ES.pdf"
    dt[1312]$url_res_fr <- "https://digitallibrary.un.org/record/419692/files/S_RES_1312%282000%29-FR.pdf"
    dt[1312]$url_res_ru <- "https://digitallibrary.un.org/record/419692/files/S_RES_1312%282000%29-RU.pdf"
    dt[1312]$url_res_zh <- "https://digitallibrary.un.org/record/419692/files/S_RES_1312%282000%29-ZH.pdf"


    ## Correct faulty URLs

    dt$url_meeting_en <- gsub("S_PV-137", "S_PV.137", dt$url_meeting_en)
    dt$url_meeting_es <- gsub("S_PV-137", "S_PV.137", dt$url_meeting_es)
    dt$url_meeting_fr <- gsub("S_PV-137", "S_PV.137", dt$url_meeting_fr)
    dt$url_meeting_ru <- gsub("S_PV-137", "S_PV.137", dt$url_meeting_ru)
    dt$url_meeting_zh <- gsub("S_PV-137", "S_PV.137", dt$url_meeting_zh)
    
    

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


    test_that("Resolution URLs are unique", {
        names.url.res <- grep("url_res", names(dt.final), value = TRUE)
        f.duplicated.NA <- function(x){duplicated(x, incomparables = NA)}
        
        for(i in names.url.res){
            expect_equal(sum(f.duplicated.NA(dt.final[[i]])),  0)            
        }
    })


    test_that("Record URLs are unique", {
        
        expect_equal(sum(duplicated(dt.final$url_record)),  0)

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
