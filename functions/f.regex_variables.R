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


    ## Load M49 codes
    m49 <- ISOcodes::UN_M.49_Countries
    setDT(m49)


    print(m49, nrows = 250)
    
    ## Simplify names to improve regex hits
    m49[ISO_Alpha_3 == "BOL"]$Name <- "Bolivia"
    m49[ISO_Alpha_3 == "BES"]$Name <- "Bonaire|(Sint Eustatius)|Saba"
    m49[ISO_Alpha_3 == "HKG"]$Name <- "Hong Kong"
    m49[ISO_Alpha_3 == "MAC"]$Name <- "Macao"
    m49[ISO_Alpha_3 == "PRK"]$Name <- "(Democratic People's Republic of Korea)|DPRK"
    m49[ISO_Alpha_3 == "FLK"]$Name <- "(Falkland Islands)|Malvinas"
    m49[ISO_Alpha_3 == "IRN"]$Name <- "Iran"
    m49[ISO_Alpha_3 == "FSM"]$Name <- "Micronesia"
    m49[ISO_Alpha_3 == "MAF"]$Name <- "Saint Martin"
    m49[ISO_Alpha_3 == "SXM"]$Name <- "Sint Maarten"
    m49[ISO_Alpha_3 == "PSE"]$Name <- "Palestine"
    m49[ISO_Alpha_3 == "SJM"]$Name <- "Svalbard|Jan Mayen"
    m49[ISO_Alpha_3 == "SYR"]$Name <- "(Syrian Arab Republic)|Syria"
    m49[ISO_Alpha_3 == "TUR"]$Name <- "Türkiye|Turkey"    
    m49[ISO_Alpha_3 == "GBR"]$Name <- "(United Kingdom of Great Britain and Northern Ireland)|(Great Britain)|(United Kingdom)"    
    m49[ISO_Alpha_3 == "TZA"]$Name <- "Tanzania"    
    m49[ISO_Alpha_3 == "VEN"]$Name <- "Venezuela"    
    

    

    regex <- paste0(iso[,.(Name, Official_name, Common_name)], collapse = "|")
    regex <- gsub("\\|NA", "", regex)

    grepl()
    
    str(iso)
    
    
    
    
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
