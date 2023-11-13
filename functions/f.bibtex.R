#' f.bibtex
#'
#' Creata bibtex database for for bl-oscola 1.7.
#'
#' @param dt.final Data.table. Final UNSC data set.
#' @param filename String. Filename for bibtex output file.
#'
#' @return String. Relative path to bibtex file.




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
                           vote_yes,
                           vote_no,
                           vote_abstention,
                           vote_nonvote,
                           vote_total,
                           vote_detail,
                           vote_date,
                           chapter6,
                           chapter7,
                           chapter8,
                           human_rights,
                           peace_threat,
                           peace_breach,
                           aggression,
                           iso_name,
                           iso_alpha3,
                           m49_countrycode,
                           m49_region,
                           m49_region_sub,
                           m49_region_intermediate,
                           notes,
                           subjects,
                           meeting_no,
                           related_resource,
                           ntokens,
                           npages,
                           url_res_en,
                           url_draft_en,
                           url_meeting_en,
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


## DEBUGGING CODE

## tar_load(dt.final)
## dt.final$date


## str(dt.bib)
## str(dt.final)

## setdiff(names(dt.final), names(dt.bib))

