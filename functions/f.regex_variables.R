#' f.regex_variables
#'
#' Create new variables by parsing text variable with regular expressions







f.regex_variables <- function(text){


    dt <- data.table(human_rights = stringi::stri_detect_regex(text, "\\bhuman *rights\\b",
                                                               case_insensitive = TRUE))

    
    
    dt$chapter6 <- stringi::stri_detect_regex(text, "\\b[Cc]hapter *VI\\b")
    dt$chapter7 <- stringi::stri_detect_regex(text, "\\b[Cc]hapter *VII\\b")
    dt$chapter8 <- stringi::stri_detect_regex(text, "\\b[Cc]hapter *VIII\\b")
    
    dt$peace_threat <- stringi::stri_detect_regex(text, "\\bthreat *to *the *peace\\b",
                                               case_insensitive = TRUE)

    dt$peace_breach <- stringi::stri_detect_regex(text, "\\bbreach *of *the *peace\\b",
                                               case_insensitive = TRUE)

    dt$aggression <- stringi::stri_detect_regex(text, "\\baggression\\b",
                                             case_insensitive = TRUE)

    dt$self_defence <- stringi::stri_detect_regex(text, "\\bself-defen[cs]e\\b",
                                               case_insensitive = TRUE)


    ## Load M49 codes
    m49 <- ISOcodes::UN_M.49_Countries
    setDT(m49)
    
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


    ## Extract ISO codes based on M49 country names
    dt$iso_alpha3 <- unlist(lapply(text, extract_countries, m49 = m49))


    ## Load ISO codes
    iso3 <- ISOcodes::ISO_3166_1
    setDT(iso3)
    
    ## ISO names
    dt$iso_name <- stringi::stri_replace_all(str = dt$iso_alpha3,
                                    regex = iso3$Alpha_3,
                                    replacement = iso3$Name,
                                    vectorize_all = FALSE)

    ## M49 codes
    dt$m49_countrycode <- stringi::stri_replace_all(str = dt$iso_alpha3,
                                           regex = m49$ISO_Alpha_3,
                                           replacement = m49$Code,
                                           vectorize_all = FALSE)

    
    ## M49 Regions
    dt$m49_region <- unlist(lapply(dt$iso_alpha3,
                                   iso_transform,
                                   output = "un.region.name"))

    ## M49 Intermediate Regions
    dt$m49_intermediateregion <- unlist(lapply(dt$iso_alpha3,
                                               iso_transform,
                                               output = "un.regionintermediate.name"))


    ## M49 Sub-Regions
    dt$m49_subregion <- unlist(lapply(dt$iso_alpha3,
                                      iso_transform,
                                      output = "un.regionsub.name"))

   


    
    return(dt)
    
}




#' Extract countries from text

#' @param str String to be searched.
#' @param m49 M49 data from ISOcodes package. This can be amended for better regex hits.



extract_countries <- function(str,
                              m49 = ISOcodes::UN_M.49_Countries){    

    hits <- stringi::stri_detect(str = str, regex = m49$Name)

    success <- sort(m49$ISO_Alpha_3[hits])

    success <- paste0(success, collapse = "|")

    return(success)


}





#' Transform one or multiple ISO3 codes per string to other formats with countrycode
#'
#' @param iso.alpa3 String. Each string may contain one or more ISO Alpha 3 codes separated by the separator string.
#' @param separator String. The separator internal to strings, default is the pipe character "|".
#' @param output String. The desired output, see {countrycodes} package for options.



iso_transform <- function(iso.alpha3,
                          separator = "\\|",
                          output){

    if(iso.alpha3 == ""){

        return("")
        
    }else{

        strings.split <- unlist(stringi::stri_split(str = iso.alpha3, regex = separator))

        transformed <- countrycode(sourcevar = strings.split,
                                   origin = "iso3c",
                                   destination = output)

        result <- paste0(sort(unique(transformed)), collapse = "|")

        return(result)
    }        
    
}

 



## DEBUGGING CODE


## tar_load(dt.intermediate)
## text <- tar_read(dt.intermediate)$text



