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

##tar_load(dt.final)
##dt.final$date
##    str(dt.final)
    

    


f.bibtex <- function(dt.final,
                     filename){


    ## Create custom variables
    
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

    ## Select pre-computed variables

    dt.bib2 <- dt.final[,.(res_no,
                           date,
                           year,
                           title,
                           other_titles,
                           summary,
                           action_note,
                           draft,
                           agenda_information,
                           vote_summary,
                           vote_detail,
                           chapter6,
                           chapter7,
                           chapter8,
                           iso_name,
                           m49_region,
                           m49_region_sub,
                           m49_region_intermediate,
                           notes,
                           subjects,
                           call_number,
                           related_resource,
                           ntokens,
                           npages,
                           version,
                           doi_concept,
                           doi_version,
                           license)]


    ## Combine data tables
    
    dt.bib <- cbind(dt.bib1, dt.bib2)


    ## Write to bibtex

    bib2df::df2bib(dt.bib, filename)

    
    return(filename)


    
}
