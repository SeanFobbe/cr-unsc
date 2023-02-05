#' Merge Data Tables
#'
#' This function merges the various data tables created by different functions into one coherent whole, which is then available for further processing.
#'
#' @param dt.res.en The English texts of UNSC resolutions.
#' @param dt.draft.en The English drafts of UNSC resolutions.
#' @param dt.meeting.en The English meeting records for UNSC resolutions.
#' @param dt.download The original download table with metadata from each record page.
#' @param dt.record.final The URLs to each record page.



f.merge_data <- function(dt.res.en,
                         dt.draft.en,
                         dt.meeting.en,
                         dt.download,
                         dt.record.final){

    
    ## Unit Test
    test_that("Arguments conform to expectations.", {
        expect_s3_class(dt.res.en, "data.table")
        expect_s3_class(dt.draft.en, "data.table")
        expect_s3_class(dt.meeting.en, "data.table")
        expect_s3_class(dt.download, "data.table")
        expect_s3_class(dt.record.final, "data.table")
    })


    
    ## Reduce Variables

    dt.draft.en <- dt.draft.en[,.(res_no, text)]
    dt.meeting.en <- dt.meeting.en[,.(res_no, text)]



    
    ## Rename Text Variables for Draft and Meeting

    names(dt.draft.en) <- gsub("text", "text_draft", names(dt.draft.en))
    names(dt.meeting.en) <- gsub("text", "text_meeting", names(dt.meeting.en))


    
    
    ## Merge Draft Texts

    dt <- merge(dt.res.en,
                dt.draft.en,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)


    ## Merge Meeting records

    dt <- merge(dt,
                dt.meeting.en,
                by = "res_no",
                all.x = TRUE,
                sort = FALSE)
    

    ## Merge Downloaded Metadata

    dt <- merge(dt,
                dt.download,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)


    
    ## Merge Record Page URL

    dt.return <- merge(dt,
                      dt.record.final,
                      by = "res_no",                
                      all.x = TRUE,
                      sort = FALSE)


    ## Rename Date Variable
    
    names(dt.return) <- gsub("date", "date_undl", names(dt.return))



    

    ## Unit Test
    test_that("Results conform to expectations.", {
        expect_s3_class(dt.return, "data.table")
        expect_equal(dt.return[,.N], dt.res.en[,.N])
        expect_gte(dt.return[,.N], dt.draft.en[,.N])
        expect_gte(dt.return[,.N], dt.meeting.en[,.N])
    })

    
    return(dt.return)
    

}
