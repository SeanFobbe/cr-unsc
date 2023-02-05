#' f.bibtex
#'
#' Creata bibtex database for for bl-oscola 1.7.
#'
#' @param dt.final Data.table. Final UNSC Data set.
#' @param filename String. Filename for Bibtex output file.
#'
#' @return String. Relative path to bibtex file.




#' to do:
#' - add date



f.bibtex <- function(dt.final,
                     filename){


    dt.bib1 <- data.table(CATEGORY = rep("MISC", nrow(dt.final)),
                          BIBTEXKEY = paste0("S_RES_",
                                             dt.final$res_no),
                          entrysubtype = rep("undoc", nrow(dt.final)),
                          tabulate = rep("undoc", nrow(dt.final)),
                          institution = rep("UNSC", nrow(dt.final)),
                          instrument_no = paste0("Res ",
                                                 dt.final$res_no,
                                                 " (", dt.final$year, ")"),
                          doc_no = paste0("UN Doc S/RES/", dt.final$res_no, "/", dt.final$year)
                          
                          )

dt.final$title
    

    months <- format(ISOdate(2004,1:12,1),"%B")
    
    date <- gsub(paste0(".* ([0-9]+) (",
                        paste0(months, collapse = "|"),
                        ") ([0-9]{4}).*"),
                 "\\1 \\2 \\3", dt.final$title)


    date <- as.Date(date, format =  "%d %B %Y")


    
    mgsub::mgsub(date, months, formatC(1:12, width = 2, flag = 0))

    
    

    

    dt.bib2 <- dt.final[,.(res_no,
                           year,
                           title,
                           other_titles,
                           summary,
                           action_note,
                           draft,
                           agenda_information,
                           description,
                           notes,
                           subjects,
                           call_number,
                           related_resource,
                           ntokens)]


    dt.bib <- cbind(dt.bib1, dt.bib2)
    
    

    str(dt.final)
    


    

    bib2df::df2bib(dt.bib, filename)

    return(filename)
    

}
