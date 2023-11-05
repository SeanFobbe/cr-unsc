#' f.langtest
#'
#' Classifies texts by language.
#' 
#' @param dt.final Data.table. The final data set.
#'
#' @return Data.table. A table of resolution numbers and language classification results.
#' 




f.langtest <- function(dt.final){


    lang.profiles <- TC_byte_profiles[names(TC_byte_profiles) %in% c("english",
                                                                     "french",
                                                                     "spanish")]
    


    en_langtest <- textcat(dt.final$text, p = lang.profiles)
    es_langtest <- textcat(dt.final$text_es, p = lang.profiles)
    fr_langtest <- textcat(dt.final$text_fr, p = lang.profiles)

    

    dt.final <- data.table(res_no = dt.final$res_no,
                           en_langtest,
                           es_langtest,
                           fr_langtest)

    return(dt.final)


}
