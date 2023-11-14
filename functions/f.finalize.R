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

    ## Remove "collections" variable (uninformative)
    dt.final$collections <- NULL

    ## Remove "authors" variable (uninformative)
    dt.final$authors <- NULL


    ## Swap "title" and "other_titles" variables

    tvars <- c("title",
               "other_titles")
    
    setnames(dt.final,
             old = tvars,
             new = rev(tvars))


    ## Convert Dates
    dt.final$action_note  <- as.IDate(dt.final$action_note)
    dt.final$vote_date  <- as.IDate(dt.final$vote_date)

    ## Correct individual vote counts

    dt.final[res_no == 1248]$vote_nonvote <- 15 # res 1248 adopted without vote
    dt.final[res_no == 1253]$vote_nonvote <- 15 # res 1253 adopted without vote
    dt.final[res_no == 1278]$vote_nonvote <- 15 # res 1278 adopted without vote
    dt.final[res_no == 1326]$vote_nonvote <- 15 # res 1326 adopted without vote
    dt.final[res_no == 1361]$vote_nonvote <- 15 # res 1361 adopted without vote    
    dt.final[res_no == 1414]$vote_nonvote <- 15 # res 1414 adopted without vote 
    dt.final[res_no == 1426]$vote_nonvote <- 15 # res 1426 adopted without vote
    dt.final[res_no == 1571]$vote_nonvote <- 15 # res 1571 adopted without vote 
    dt.final[res_no == 1691]$vote_nonvote <- 15 # res 1691 adopted without vote 
    dt.final[res_no == 1999]$vote_nonvote <- 15 # res 1999 adopted without vote
    dt.final[res_no == 2034]$vote_nonvote <- 15 # res 2034 adopted without objections
    dt.final[res_no == 2705]$vote_yes  <- 15 # res 2705 adopted unanimously


    
    ## Fix NA votes
    
    dt.final[is.na(vote_yes)]$vote_yes <- 0
    dt.final[is.na(vote_no)]$vote_no <- 0
    dt.final[is.na(vote_abstention)]$vote_abstention <- 0
    dt.final[is.na(vote_nonvote)]$vote_nonvote <- 0

    total.na <- is.na(dt.final$vote_total)
    
    dt.final[total.na]$vote_total <- dt.final[total.na]$vote_yes + dt.final[total.na]$vote_no + dt.final[total.na]$vote_abstention + dt.final[total.na]$vote_nonvote






    
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



    

    ## UNIT TESTS ##


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

    
    test_that("URLs are valid", {

        names.url.record <- grep("url_record", names(dt.final), value = TRUE)

        for(i in names.url.record){

            vec <- na.omit(unlist(dt.final[,..i]))
            grep <- grepl("https://digitallibrary.un.org/record/[0-9+]", vec)
            expect_true(all(grep))

        }

        names.url.files <- grep("url_res|url_meeting|url_draft", names(dt.final), value = TRUE)

        for(i in names.url.files){

            vec <- na.omit(unlist(dt.final[,..i]))
            grep <- grepl("https://digitallibrary.un.org/record/.*\\.pdf", vec)
            expect_true(all(grep))

        }

    })

    
    test_that("Dates are in ISO format.", {
        expect_true(all(grepl("[0-9]{4}-[0-9]{2}-[0-9]{2}", na.omit(dt.final$date))))
        expect_true(all(grepl("[0-9]{4}-[0-9]{2}-[0-9]{2}", na.omit(dt.final$action_note))))
    })


    ## Uniqueness
    test_that("Resolution URLs are unique", {
        names.url.res <- grep("url_res", names(dt.final), value = TRUE)
        f.duplicated.NA <- function(x){duplicated(x, incomparables = NA)}
        
        for(i in names.url.res){
            expect_equal(sum(f.duplicated.NA(dt.final[[i]])),  0)            
        }
    })


    test_that("Record URLs are unique", {
        
        expect_equal(sum(duplicated(dt.final$url_record)),  0)

    })

    test_that("Identifiers are unique.", {
        expect_equal(sum(duplicated(dt.final$doc_id)),  0)
        expect_equal(sum(duplicated(dt.final$res_no)),  0)
        expect_equal(sum(duplicated(dt.final$symbol)),  0)
    })


    ## Sets
    test_that("Body and Doctype are correct", {
        expect_length(setdiff(dt.final$body, "S"), 0)
        expect_length(setdiff(dt.final$doctype, "RES"), 0)
    })

    

    ## Year and Date Boundaries
    
    test_that("Years are within acceptable bounds", {
        expect_true(all(dt.final$year >= 1946))
        expect_true(all(dt.final$year <= year(Sys.Date())))    
    })

    test_that("Dates are within acceptable bounds", {
        expect_true(all(na.omit(dt.final$date) >= "1946-01-25"))
        expect_true(all(na.omit(dt.final$vote_date) >= "1946-01-25"))
        expect_true(all(na.omit(dt.final$action_note) >= "1946-01-25"))
        expect_true(all(na.omit(dt.final$date) <= Sys.Date()))
        expect_true(all(na.omit(dt.final$vote_date) <= Sys.Date()))
        expect_true(all(na.omit(dt.final$action_note) <= Sys.Date()))
    })

    

    ## Voting Boundaries

    test_that("Vote count minima are within acceptable bounds", {
        expect_true(all(dt.final$vote_total >= 0))
        expect_true(all(dt.final$vote_yes >= 0))
        expect_true(all(dt.final$vote_no >= 0))
        expect_true(all(dt.final$vote_abstention >= 0))
        expect_true(all(dt.final$vote_nonvote >= 0))
    })

    test_that("Vote count maxima are within acceptable bounds", {
        expect_setequal(unique(dt.final$vote_total), c(11, 15))
        expect_true(all(dt.final$vote_yes <= 15))
        expect_true(all(dt.final$vote_no <= 15))
        expect_true(all(dt.final$vote_abstention <= 15))
        expect_true(all(dt.final$vote_nonvote <= 15))
    })

    test_that("Vote count sums are correct", {
        vote.sum <- dt.final$vote_yes + dt.final$vote_no + dt.final$vote_abstention + dt.final$vote_nonvote
        expect_identical(vote.sum, dt.final$vote_total)
    })



    
    ## Linguistic Variables
    test_that("Linguistic variables minima are within acceptable bounds.", {
        expect_true(all(dt.final$nchars >= 0))
        expect_true(all(dt.final$ntokens >= 0))
        expect_true(all(dt.final$ntypes >= 0))
        expect_true(all(dt.final$nsentences >= 0))
        expect_true(all(na.omit(dt.final$npages) >= 0))
    })

    test_that("Linguistic variables minima are within acceptable bounds.", {
        expect_true(all(dt.final$nchars < 1e6))
        expect_true(all(dt.final$ntokens < 1e5))
        expect_true(all(dt.final$ntypes < 1e4))
        expect_true(all(dt.final$nsentences < 1e4))
        expect_true(all(na.omit(dt.final$npages) < 110))
    })
    
    

    return(dt.final)

}



## DEBUGGING Code

## library(data.table)
## library(testthat)
## tar_load(dt.intermediate)
## vars.additional <- tar_read(vars_additional)
## varnames  <- tar_read(dt.var_codebook)$varname
## debug.toggle = FALSE
## varnames <- fread("data/CR-UNSC_Variables.csv")$varname



## Check problematic votes    
#dt.final[vote_total != vote.sum, .(res_no, vote_yes, vote_no, vote_abstention, vote_nonvote, topic)]

## Check problematic varnames
## setdiff(names(dt.final), varnames)





