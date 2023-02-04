


f.citation_extraction <- function(text){


    res <- stringi::stri_extract_all(text, regex = "[0-9]{1,4} \\([0-9]{4}\\)")


    }
