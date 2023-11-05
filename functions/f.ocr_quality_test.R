#' f.ocr_quality_test
#'
#' Test OCR and gold standard revision quality.
#'
#' @param dt.res.en.gold Data.table. The English language gold standard resolution texts.
#' @param dt.ocr.res.all Data.table. The OCR texts for all resolutions.
#' @param dt.extracted.res.all Data.table. The extracted texts for all resolutions.




f.ocr_quality_test <- function(dt.res.en.gold,
                               dt.ocr.res.all,
                               dt.extracted.res.all){



    ## English

    quanteda_options(tokens_locale = "en") # Locale for Tokenization
    
    test.en.gold <- dt.res.en.gold[,doc_id := res_no][,.(doc_id, text)]
    
    gold.resno <- dt.res.en.gold$res_no #  Limit comparison to Gold Res Nos
    
    test.en.extracted <- dt.extracted.res.all[(res_no  %in% gold.resno) & language == "EN"][,doc_id := res_no][,.(doc_id, text)]

    test.en.ocr <- dt.ocr.res.all[(res_no  %in% gold.resno) & language == "EN"][,doc_id := res_no][,.(doc_id, text)]

    
    dfm.en.gold <- dfm(f.token.processor(corpus(test.en.gold)))
    dfm.en.extracted <- dfm(f.token.processor(corpus(test.en.extracted)))
    dfm.en.ocr <- dfm(f.token.processor(corpus(test.en.ocr)))


    ## French

    quanteda_options(tokens_locale = "fr") # Locale for Tokenization


    test.fr.extracted <- dt.extracted.res.all[(res_no  %in% gold.resno) &language == "FR"][,doc_id := res_no][,.(doc_id, text)]

    test.fr.ocr <- dt.ocr.res.all[(res_no  %in% gold.resno) &language == "FR"][,doc_id := res_no][,.(doc_id, text)]

    dfm.fr.extracted <- dfm(f.token.processor(corpus(test.fr.extracted)))
    dfm.fr.ocr <- dfm(f.token.processor(corpus(test.fr.ocr)))


    ## Spanish

    quanteda_options(tokens_locale = "es") # Locale for Tokenization

    test.es.extracted <- dt.extracted.res.all[(res_no  %in% gold.resno) &language == "ES"][,doc_id := res_no][,.(doc_id, text)]

    test.es.ocr <- dt.ocr.res.all[(res_no  %in% gold.resno) &language == "ES"][,doc_id := res_no][,.(doc_id, text)]

    dfm.es.extracted <- dfm(f.token.processor(corpus(test.es.extracted)))
    dfm.es.ocr <- dfm(f.token.processor(corpus(test.es.ocr)))

    


    
    ## Collate results
    
    dt.final  <- data.table(language = c("English",
                                         "English",
                                         "English",
                                         "French",
                                         "French",
                                         "Spanish",
                                         "Spanish"),
                            processing = c("Extracted",
                                           "OCR",
                                           "Gold",
                                           "Extracted",
                                           "OCR",
                                           "Extracted",
                                           "OCR"),
                            features = c(nfeat(dfm.en.extracted),
                                         nfeat(dfm.en.ocr),
                                         nfeat(dfm.en.gold),
                                         nfeat(dfm.fr.extracted),
                                         nfeat(dfm.fr.ocr),
                                         nfeat(dfm.es.extracted),
                                         nfeat(dfm.es.ocr)))


    return(dt.final)


}




## DEBUGING CODE

## dt.res.en.gold <- tar_read(dt_res_en_gold)
## dt.ocr.res.all <- tar_read(dt_ocr_res_all)
## dt.extracted.res.all <- tar_read(dt_extracted_res_all)




#'# Process Corpus to Tokens
#' This function tokenizes a corpus, removes irrelevant characters, converts to lowercase and removes common stopwords for both English and French. It is intended to simulate a generic and widespread pre-processing workflow in natural language processing.


f.token.processor <- function(corpus){
    tokens <- tokens(corpus,
                     remove_numbers = TRUE,
                     remove_punct = TRUE,
                     remove_symbols = TRUE,
                     remove_separators = TRUE)
    tokens <- tokens_tolower(tokens)
    tokens <- tokens_remove(tokens,
                            pattern = c(stopwords("english"),
                                        stopwords("french"),
                                        stopwords("spanish")))
    return(tokens)
}

