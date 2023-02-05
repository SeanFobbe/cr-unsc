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