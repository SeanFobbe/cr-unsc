#' Merge Data Tables
#'
#' This function merges the various data tables created by different functions into one coherent whole, which is then available for further processing.
#'
#' @param dt.extracted.res.all The hexalingual set of extracted texts of UNSC resolutions.
#' @param dt.ocr.res.all The hexalingual set of OCR texts of UNSC resolutions.
#' @param dt.res.en.gold The gold-standard manually reviewed English texts of UNSC resolutions.
#' @param dt.draft.all The English draft texts (OCR and extracted) of UNSC resolutions.
#' @param dt.meeting.all The English meeting record texts (OCR and extracted) for UNSC resolutions.
#' @param dt.download The original download table with metadata from each record page.
#' @param dt.record.final The URLs to each record page.
#' @param dt.voting The voting data collected from each record page.
#' @param ocr.limit The set of resolutions up to which scanning (non-born-digital) is assumed and OCR is performed.



f.merge_data <- function(dt.extracted.res.all,
                         dt.ocr.res.all,
                         dt.res.en.gold,
                         dt.draft.all,
                         dt.meeting.all,
                         dt.download.final,
                         dt.record.final,
                         dt.voting,
                         ocr.limit = 899){

    
    ## Unit test
    test_that("Arguments conform to expectations.", {
        expect_s3_class(dt.extracted.res.all, "data.table")
        expect_s3_class(dt.ocr.res.all, "data.table")
        expect_s3_class(dt.res.en.gold, "data.table")
        expect_s3_class(dt.draft.all, "data.table")
        expect_s3_class(dt.meeting.all, "data.table")
        expect_s3_class(dt.download.final, "data.table")
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
                       fill = TRUE)[,.(res_no, text)][order(res_no)]

    setnames(dt.res.ar, "text", "text_ar")
    
    dt <- merge(dt,
                dt.res.ar,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)

    
    ## Merge Spanish resolution texts
    dt.res.es <- rbind(dt.ocr.res.all[language == "ES"],
                       dt.extracted.res.all[res_no > ocr.limit & language == "ES"],
                       fill = TRUE)[,.(res_no, text)][order(res_no)]

    setnames(dt.res.es, "text", "text_es")
    
    dt <- merge(dt,
                dt.res.es,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)

    
    ## Merge French resolution texts
    dt.res.fr <- rbind(dt.ocr.res.all[language == "FR"],
                       dt.extracted.res.all[res_no > ocr.limit & language == "FR"],
                       fill = TRUE)[,.(res_no, text)][order(res_no)]

    setnames(dt.res.fr, "text", "text_fr")
    
    dt <- merge(dt,
                dt.res.fr,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)

    
    ## Merge Russian resolution texts
    dt.res.ru <- rbind(dt.ocr.res.all[language == "RU"],
                       dt.extracted.res.all[res_no > ocr.limit & language == "RU"],
                       fill = TRUE)[,.(res_no, text)][order(res_no)]
    
    setnames(dt.res.ru, "text", "text_ru")
    
    dt <- merge(dt,
                dt.res.ru,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)

    
    ## Merge Chinese resolution texts
    dt.res.zh <- rbind(dt.ocr.res.all[language == "ZH"],
                       dt.extracted.res.all[res_no > ocr.limit & language == "ZH"],
                       fill = TRUE)[,.(res_no, text)][order(res_no)]

    setnames(dt.res.zh, "text", "text_zh")
    
    dt <- merge(dt,
                dt.res.zh,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)


    ## Merge draft texts

    dt.draft.en <- rbind(dt.draft.all[docvar7 == "TESSERACT"],
                         dt.draft.all[res_no > ocr.limit & is.na(docvar7)],
                         fill = TRUE)[,.(res_no, text)][order(res_no)]

    setnames(dt.draft.en, "text", "text_draft")

    dt <- merge(dt,
                dt.draft.en,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)


    ## Merge meeting record texts

    dt.meeting.en <- rbind(dt.meeting.all[docvar7 == "TESSERACT"],
                         dt.meeting.all[res_no > ocr.limit & is.na(docvar7)],
                         fill = TRUE)[,.(res_no, text)][order(res_no)]

    setnames(dt.meeting.en, "text", "text_meeting")
    
    dt <- merge(dt,
                dt.meeting.en,
                by = "res_no",                
                all.x = TRUE,
                sort = FALSE)
    
        

    ## Merge downloaded metadata
    
    dt <- merge(dt,
                dt.download.final[,!c("doc_id", "year", "vote_summary")],
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

    ## Finalize
    dt.final <- dt
    

    ## Rename date variable
    names(dt.final) <- gsub("^date$", "date_undl", names(dt.final))



    

    ## Unit test

    test_that("Type is correct.", {
        expect_s3_class(dt.final, "data.table")
    })

    
    test_that("Number of rows after merge is reasonable.", {
        expect_equal(dt.final[,.N], dt.extracted.res.all[language == "EN",.N])
        expect_lte(dt.final[,.N], dt.voting[,.N])
        expect_gte(dt.final[,.N], dt.draft.all[is.na(docvar7),.N])
        expect_gte(dt.final[,.N], dt.meeting.all[is.na(docvar7),.N])
    })
    
    
    test_that("No disambiguated column names from merge.", {

        expect_length(grep("\\.x", names(dt.final), value = T), 0)
        
    })

    

    
    return(dt.final)
    

}



## DEBUGGING Code


## library(data.table)
## library(testthat)
## dt.res.en = tar_read(dt_res_en)
## dt.res.en.gold = tar_read(dt_res_en_gold)
## dt.draft.en = tar_read(dt_draft_en)
## dt.meeting.en = tar_read(dt_meeting_en)
## dt.download.final = tar_read(dt.download.final)
## dt.record.final = tar_read(dt.record.final)
## dt.voting = tar_read(dt.voting)

## dt.extracted.res.all <- tar_read(dt_extracted_res_all)
## dt.ocr.res.all <- tar_read(dt_ocr_res_all)
## dt.draft.all <- tar_read(dt_draft_all)
## dt.meeting.all <- tar_read(dt_meeting_all)
