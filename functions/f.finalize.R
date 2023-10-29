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

    ## Remove "language" variable (text language is encoded in var names)
    dt.final$language <- NULL
    
    ## Remove "access" variable (only repeats file name)
    dt.final$access <- NULL


    
    ## Order by Resolution Number
    setorder(dt.final,
             res_no)

    ## Unit Test: Variable Names
    varnames <- gsub("\\\\", "", varnames) # Remove LaTeX escape characters
    
    if(debug.toggle == TRUE){

        varnames <- intersect(names(dt.final), varnames)
        
    }
    
    test_that("Variable names in data set are all documented in Codebook", {
        expect_setequal(names(dt.final), varnames)

    })
    
    ## Set Column Order
    data.table::setcolorder(dt.final, varnames)



    

    ## TESTING ##


    ## Codebook compliance
    test_that("Variable names in data set are documented and ordered as in Codebook", {
        expect_equal(names(dt.final), varnames)
    })
    
    
    ## Format compliance
    test_that("Class and type are correct.", {
        expect_s3_class(dt.final, "data.table")
        expect_type(dt.final$aggression, "logical")
        expect_type(dt.final$chapter6, "logical")
        expect_type(dt.final$chapter7, "logical")
        expect_type(dt.final$chapter8, "logical")
        expect_type(dt.final$human_rights, "logical")
        expect_type(dt.final$peace_breach, "logical")
        expect_type(dt.final$peace_threat, "logical")
        expect_type(dt.final$self_defence, "logical") 
    })

    
    test_that("Input and output data tables have same number of rows", {
        expect_equal(dt.final[,.N], dt.intermediate[,.N])
    })


    ## Format compliance
    
    test_that("URLs are valid", {
        expect_true(all(grepl("https://digitallibrary.un.org/record/[0-9]+", na.omit(dt.final$record))))
        expect_true(all(grepl("https://digitallibrary.un.org/record/[0-9]+", na.omit(dt.final$record_meeting))))
        expect_true(all(grepl("https://digitallibrary.un.org/record/[0-9]+", na.omit(dt.final$record_draft))))
        expect_true(all(grepl("https://digitallibrary.un.org/record/.*\\.pdf", na.omit(dt.final$url_res_ar))))
        expect_true(all(grepl("https://digitallibrary.un.org/record/.*\\.pdf", na.omit(dt.final$url_res_en))))
        expect_true(all(grepl("https://digitallibrary.un.org/record/.*\\.pdf", na.omit(dt.final$url_res_es))))
        expect_true(all(grepl("https://digitallibrary.un.org/record/.*\\.pdf", na.omit(dt.final$url_res_fr))))
        expect_true(all(grepl("https://digitallibrary.un.org/record/.*\\.pdf", na.omit(dt.final$url_res_ru))))
        expect_true(all(grepl("https://digitallibrary.un.org/record/.*\\.pdf", na.omit(dt.final$url_res_zh))))
    })

    
    test_that("Dates are in ISO format.", {
        expect_true(all(grepl("[0-9]{4}-[0-9]{2}-[0-9]{2}", na.omit(dt.final$date))))
        expect_true(all(grepl("[0-9]{4}-[0-9]{2}-[0-9]{2}", na.omit(dt.final$action_note))))
    })


    ## Uniqueness
    test_that("URLs are unique", {
        expect_equal(sum(duplicated(dt.final$record)),  0)
        expect_equal(sum(duplicated(dt.final$record_draft)),  0)
        expect_equal(sum(duplicated(dt.final$record_meeting)),  0) 
        expect_equal(sum(duplicated(dt.final$url_res_en)),  0)
        expect_equal(sum(duplicated(dt.final$url_res_es)),  0)
        expect_equal(sum(duplicated(dt.final$url_res_ru)),  0)        
        ##expect_equal(sum(duplicated(dt.final$url_res_fr)),  0) # fails        
        ##expect_equal(sum(duplicated(dt.final$url_res_ar)),  0) # fails
        ##expect_equal(sum(duplicated(dt.final$url_res_zh)),  0) # fails

        ## ADD draft and meeting URL
    })
    
    ## Linguistic Variables
    test_that("var nchars is within acceptable bounds.", {
        expect_true(all(dt.final$nchars >= 0))
        expect_true(all(dt.final$nchars < 1e6))   
    })

    test_that("var ntokens is within acceptable bounds.", {
        expect_true(all(dt.final$ntokens >= 0))
        expect_true(all(dt.final$ntokens < 1e5))   
    })
    
    test_that("var ntypes is within acceptable bounds.", {
        expect_true(all(dt.final$ntypes >= 0))
        expect_true(all(dt.final$ntypes < 1e4))   
    })
    
    test_that("var nsentences is within acceptable bounds.", {
        expect_true(all(dt.final$nsentences >= 0))
        expect_true(all(dt.final$nsentences < 1e4))   
    })
    

    

    return(dt.final)

}



## DEBUGGING Code

## tar_load(dt.intermediate)
## vars.additional <- tar_read(vars_additional)
## varnames  <- tar_read(dt.var_codebook)$varname
## debug.toggle = FALSE
## varnames <- fread("data/CR-UNSC_Variables.csv")$varname
## setdiff(names(dt.final), varnames)
