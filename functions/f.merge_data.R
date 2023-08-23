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



f.merge_data <- function(dt.extracted.res.all,
                         dt.ocr.res.all,
                         dt.res.en.gold,
                         dt.draft.en,
                         dt.meeting.en,
                         dt.download,
                         dt.record.final,
                         dt.voting,
                         ocr.limit = 899){

    
    ## Unit test
    test_that("Arguments conform to expectations.", {
        expect_s3_class(dt.res.en.gold, "data.table")
        expect_s3_class(dt.draft.en, "data.table")
        expect_s3_class(dt.meeting.en, "data.table")
        expect_s3_class(dt.download, "data.table")
        expect_s3_class(dt.record.final, "data.table")
        expect_s3_class(dt.voting, "data.table")
    })

    
    ## Merge English digital texts with gold-standard resolutions 

    dt.res.en.gold$docvar6 <- NULL
    dt.res.en.digital <- dt.extracted.res.all[language == "EN"]
    dt.res.en.digital <- dt.res.en.digital[!res_no %in% dt.res.en.gold$res_no]
    dt <- rbind(dt.res.en.gold, dt.res.en.digital)[order(res_no)]

    
    ## Merge Arabic resolution texts
    dt.res.ar <- rbind(dt.ocr.res.all[language == "AR"],
                       dt.extracted.res.all[res_no > ocr.limit & language == "AR"],
                       fill = TRUE)[,.(res_no, text)]

    setnames(dt.res.ar, "text", "text_ar")
    
    dt <- merge(dt,
                dt.res.ar,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)

    
    ## Merge Spanish resolution texts
    dt.res.es <- rbind(dt.ocr.res.all[language == "ES"],
                       dt.extracted.res.all[res_no > ocr.limit & language == "ES"],
                       fill = TRUE)[,.(res_no, text)]

    setnames(dt.res.es, "text", "text_es")
    
    dt <- merge(dt,
                dt.res.es,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)

    
    ## Merge French resolution texts
    dt.res.fr <- rbind(dt.ocr.res.all[language == "FR"],
                       dt.extracted.res.all[res_no > ocr.limit & language == "FR"],
                       fill = TRUE)[,.(res_no, text)]

    setnames(dt.res.fr, "text", "text_fr")
    
    dt <- merge(dt,
                dt.res.fr,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)

    
    ## Merge Russian resolution texts
    dt.res.ru <- rbind(dt.ocr.res.all[language == "RU"],
                       dt.extracted.res.all[res_no > ocr.limit & language == "RU"],
                       fill = TRUE)[,.(res_no, text)]
    
    setnames(dt.res.ru, "text", "text_ru")
    
    dt <- merge(dt,
                dt.res.ru,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)

    
    ## Merge Chinese resolution texts
    dt.res.zh <- rbind(dt.ocr.res.all[language == "ZH"],
                       dt.extracted.res.all[res_no > ocr.limit & language == "ZH"],
                       fill = TRUE)[,.(res_no, text)]

    setnames(dt.res.zh, "text", "text_zh")
    
    dt <- merge(dt,
                dt.res.zh,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)


    ## Merge draft texts

    dt.draft.en <- rbind(dt.draft.all[docvar7 == "TESSERACT"],
                         dt.draft.all[res_no > ocr.limit & is.na(docvar7)],
                         fill = TRUE)[,.(res_no, text)]

    setnames(dt.draft.en, "text", "text_draft")

    dt <- merge(dt,
                dt.draft.en,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)


    ## Merge meeting record texts

    dt.meeting.en <- rbind(dt.meeting.all[docvar7 == "TESSERACT"],
                         dt.meeting.all[res_no > ocr.limit & is.na(docvar7)],
                         fill = TRUE)[,.(res_no, text)]

    setnames(dt.meeting.en, "text", "text_meeting")
    
    dt <- merge(dt,
                dt.meeting.en,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)
    
    
    
    str(dt.draft.all)

    unique(dt.draft.all$docvar7)
    
    ## Remove variables

    dt.draft.en <- dt.draft.en[,.(res_no, text)]
    dt.meeting.en <- dt.meeting.en[,.(res_no, text)]

    
    ## Rename text variables for draft and meeting

    names(dt.draft.en) <- gsub("text", "text_draft", names(dt.draft.en))
    names(dt.meeting.en) <- gsub("text", "text_meeting", names(dt.meeting.en))


    
    





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
#        expect_equal(dt.return[,.N], dt.res.en[,.N])
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
