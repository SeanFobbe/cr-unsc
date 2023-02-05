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
                          institution = rep("UN Security Council", nrow(dt.final)),
                          instrument_no = 
                          
                          )



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
    
    

    str(dt.bib)
    


    

    bib2df::df2bib(dt.bib, filename)

    return(filename)
    

}
