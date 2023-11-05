#' f.langtest
#'
#' Classifies texts by language.
#' 
#' @param dt.final Data.table. The final data set.
#'
#' @return Data.table. A table of resolution numbers and language classification results.
#' 




f.langtest <- function(dt.final){


    lang.profiles <- TC_byte_profiles[names(TC_byte_profiles) %in% c("arabic-iso8859_6",
                                                                     "arabic-windows1256",
                                                                     "english",
                                                                     "french",
                                                                     "spanish",
                                                                     "chinese-big5",
                                                                     "chinese-gb2312",
                                                                     "russian-iso8859_5",
                                                                     "russian-koi8_r",
                                                                     "russian-windows1251")]
    

    ar_langtest <- textcat(dt.final$text_ar, p = lang.profiles)
    en_langtest <- textcat(dt.final$text, p = lang.profiles)
    es_langtest <- textcat(dt.final$text_es, p = lang.profiles)
    fr_langtest <- textcat(dt.final$text_fr, p = lang.profiles)
    ru_langtest <- textcat(dt.final$text_ru, p = lang.profiles)
    zh_langtest <- textcat(dt.final$text_zh, p = lang.profiles)
    

    dt.final <- data.table(res_no = dt.final$res_no,
                           ar_langtest,
                           en_langtest,
                           es_langtest,
                           fr_langtest,
                           ru_langtest,
                           zh_langtest)

    return(dt.final)


}
