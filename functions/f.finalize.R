#' Finalize the Main Data Set

#' @param dt.intermediate Data.table. The merged data table that contains individual texts and metadata.
#' @param vars.additional Data.table. Additional variables computed from the dt.intermediate table.
#' @param varnames String. The exact variable names in the order in which they should appear in the Codebook. Wrong variable names will raise an error. 



#' @return Data.table. The final data set.





f.finalize <- function(dt.intermediate,
                       vars.additional,
                       varnames,
                       debug.toggle = FALSE){

    ## Unit Test
    test_that("Arguments conform to expectations.", {
        expect_s3_class(dt.intermediate, "data.table")
        expect_s3_class(vars.additional, "data.table")
        expect_equal(vars.additional[,.N], dt.intermediate[,.N])
    })


    

    ## Bind Additional Variables
    
    dt.final <- cbind(dt.intermediate,
                      vars.additional)

    
    ## Create "meeting_no" variable
    ## Note: does not contain meeting numbers for all resolutions
    
    meeting_no <- unlist(stringi::stri_extract_all(dt.final$title,
                                                   regex = "([0-9]+)\\s*[a-z]+\\s*meeting",
                                                   case_insensitive = TRUE))

    dt.final$meeting_no <- as.integer(unlist(stringi::stri_extract_all(meeting_no,
                                                                       regex = "[0-9]+")))


    ## Create "topic" variable (topic of specific resolutions)

    dt.final$topic <- gsub(".*\\[(.*)\\].*", "\\1", dt.final$other_title)
    dt.final$topic <- gsub(" +|\n+", " ", dt.final$topic)

    
    ## Create "npage" variable
    dt.final$npages <- as.integer(gsub("\\[?([0-9]+)\\]? *p\\.?", "\\1", dt.final$description))


    
    ## Remove "description" variable (contains only page numbers now available in "npages")
    dt.final$description <- NULL

    ## Remove "date_undl" variable (contains only date, "New York" and "UN"; date is separate variable now)

    dt.final$date_undl <- NULL
    
    
    ## Order by Resolution Number

    setorder(dt.final,
             res_no)


    
    ## Unit Test: Check variables and set column order

    varnames <- gsub("\\\\", "", varnames) # Remove LaTeX escape characters
    
    if(debug.toggle == TRUE){

        varnames <- intersect(names(dt.final), varnames)
        
        }
    
    data.table::setcolorder(dt.final, varnames)

    

    ## Unit Test
    test_that("Result conforms to expectations.", {
        expect_s3_class(dt.final, "data.table")
        expect_equal(dt.final[,.N], dt.intermediate[,.N])
    })


    return(dt.final)

}



## DEBUGGING Code

## tar_load(dt.intermediate)
## vars.additional <- tar_read(vars_additional)
## varnames  <- tar_read(dt.var_codebook)$varname
## debug.toggle = FALSE
## varnames <- fread("data/CR-UNSC_Variables.csv")$varname
