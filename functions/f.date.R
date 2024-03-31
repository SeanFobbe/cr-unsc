#' f.date
#'
#' Extract date from string in format "1 November 2020" and convert to ISO format.
#'
#' @param string Character. A string vector that contains the dates and possibly other irrelevant text.
#' @return date Date object. The extracted date in ISO format, e.g. 1946-04-04




f.date <- function(string){


    months <- format(ISOdate(2004,1:12,1),"%B")
    
    date <- gsub(paste0(".* ([0-9]+) (",
                        paste0(months, collapse = "|"),
                        ") ([0-9]{4}).*"),
                 "\\1 \\2 \\3",
                 string)


    date <- as.Date(date, format =  "%d %B %Y")



    return(date)


    

}
