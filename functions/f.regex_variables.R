#' f.regex_variables
#'
#' Create new variables by parsing text variable with regular expressions







f.regex_variables <- function(text){



    human_rights <- stringi::stri_detect_regex(text, "\\bhuman *rights\\b",
                                               case_insensitive = TRUE)
    
    chapter6 <- stringi::stri_detect_regex(text, "\\bChapter *VI\\b")
    chapter7 <- stringi::stri_detect_regex(text, "\\bChapter *VII\\b")
    chapter8 <- stringi::stri_detect_regex(text, "\\bChapter *VIII\\b")
    
    peace_threat <- stringi::stri_detect_regex(text, "\\bthreat *to *the *peace\\b",
                                               case_insensitive = TRUE)

    peace_breach <- stringi::stri_detect_regex(text, "\\bbreach *of *the *peace\\b",
                                               case_insensitive = TRUE)

    aggression <- stringi::stri_detect_regex(text, "\\baggression\\b",
                                             case_insensitive = TRUE)

    self_defence <- stringi::stri_detect_regex(text, "\\bself-defen[cs]e\\b",
                                               case_insensitive = TRUE)

    
    dt.return <- data.table(human_rights,
                            chapter6,
                            chapter7,
                            chapter8,
                            peace_threat,
                            peace_breach,
                            aggression,
                            self_defence)



    
    return(dt.return)
    
}


## DEBUGGING CODE

## text <- tar_read(dt.intermediate)$text
