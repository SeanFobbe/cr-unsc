#' Merge Data Tables
#'
#' This function merges the various data tables created by different functions into one coherent whole, which is then available for further processing.
#'
#' @param dt.res.en The English texts of UNSC resolutions.
#' @param dt.res.en.gold The gold-standard manually reviewed English texts of UNSC resolutions.
#' @param dt.draft.en The English draft texts of UNSC resolutions.
#' @param dt.meeting.en The English meeting record texts for UNSC resolutions.
#' @param dt.download The original download table with metadata from each record page.
#' @param dt.record.final The URLs to each record page.
#' @param dt.voting The voting data collected from each record page.



f.merge_data <- function(dt.res.en,
                         dt.res.en.gold,
                         dt.draft.en,
                         dt.meeting.en,
                         dt.download,
                         dt.record.final,
                         dt.voting){

    
    ## Unit test
    test_that("Arguments conform to expectations.", {
        expect_s3_class(dt.res.en, "data.table")
        expect_s3_class(dt.res.en.gold, "data.table")
        expect_s3_class(dt.draft.en, "data.table")
        expect_s3_class(dt.meeting.en, "data.table")
        expect_s3_class(dt.download, "data.table")
        expect_s3_class(dt.record.final, "data.table")
        expect_s3_class(dt.voting, "data.table")
    })

    
    ## Merge English digital texts with gold-standard resolutions 

    dt.res.en.gold$docvar6 <- NULL
    dt.res.en.digital <- dt.res.en[!res_no %in% dt.res.en.gold$res_no]
    dt.res.en <- rbind(dt.res.en.gold, dt.res.en.digital)[order(res_no)]


    ## ## Merge Arabic resolution texts

    ## dt.res.all[language == "EN"]

    
    
    ## Remove variables

    dt.draft.en <- dt.draft.en[,.(res_no, text)]
    dt.meeting.en <- dt.meeting.en[,.(res_no, text)]

    
    ## Rename text variables for draft and meeting

    names(dt.draft.en) <- gsub("text", "text_draft", names(dt.draft.en))
    names(dt.meeting.en) <- gsub("text", "text_meeting", names(dt.meeting.en))


    
    
    ## Merge draft texts

    dt <- merge(dt.res.en,
                dt.draft.en,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)


    ## Merge meeting records

    dt <- merge(dt,
                dt.meeting.en,
                by = "res_no",
                all.x = TRUE,
                sort = FALSE)
    

    ## Merge downloaded metadata

    dt <- merge(dt,
                dt.download,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)


    ## Merge voting data

    dt.voting$resolution <- NULL
    
    dt <- merge(dt,
                dt.voting,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)


    
    ## Merge record page URL

    dt.return <- merge(dt,
                      dt.record.final,
                      by = "res_no",                
                      all.x = TRUE,
                      sort = FALSE)


    

    ## Rename date variable
    
    names(dt.return) <- gsub("^date$", "date_undl", names(dt.return))



    

    ## Unit test
    test_that("Results conform to expectations.", {
        expect_s3_class(dt.return, "data.table")
        expect_equal(dt.return[,.N], dt.res.en[,.N])
        expect_lte(dt.return[,.N], dt.voting[,.N])
        expect_gte(dt.return[,.N], dt.draft.en[,.N])
        expect_gte(dt.return[,.N], dt.meeting.en[,.N])
    })

    
    return(dt.return)
    

}



## DEBUGGING Code

## dt.res.en = tar_read(dt_res_en)
## dt.res.en.gold = tar_read(dt_res_en_gold)
## dt.draft.en = tar_read(dt_draft_en)
## dt.meeting.en = tar_read(dt_meeting_en)
## dt.download = tar_read(dt.download)
## dt.record.final = tar_read(dt.record.final)
## dt.voting = tar_read(dt.voting)

## dt.extracted.res.all <- tar_read(dt_extracted_res_all)
## dt.ocr.res.all <- tar_read(dt_ocr_res_all)
## dt.draft.all <- tar_read(dt_draft_all)
## dt.meeting.all <- tar_read(dt_meeting_all)
