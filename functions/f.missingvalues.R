#' f.missingvalues
#'
#' Summarize missing values in data.frame or data.table
#'
#' @param x A data.frame or data.table to be inspected.
#' @param kable Whether to output results as Kable tables.
#' @param dir.out Output directory to write CSV files to. Does not write CSV files if NULL. (default).
#' @param prefix.files Optional prefix to add to files.




f.missingvalues <- function(x,
                            kable = FALSE,
                            dir.out = NULL,
                            prefix.files = ""){



    vec.na <- is.na(x)
    
    values.missing <- apply(vec.na, 2, sum)
    values.present <- nrow(x) - apply(vec.na, 2, sum)


    
    dt.values.missing <- transpose(data.frame(as.list(values.missing)), keep.names = "var")
    setDT(dt.values.missing)
    setnames(dt.values.missing, new = c("var", "missing"))

    dt.values.present <- transpose(data.frame(as.list(values.present)), keep.names = "var")
    setDT(dt.values.present)
    setnames(dt.values.present, new = c("var", "present"))


    

    if(is.null(dir.out) == FALSE){
        
        fwrite(dt.values.present,
               file.path(dir.out,
                         paste0(prefix.files, "Values-Present.csv")))

        fwrite(dt.values.missing,
               file.path(dir.out,
                         paste0(prefix.files, "Values-Missing.csv")))


    }

  if (kable == TRUE){

            cat("\n------------------------------------------------\n")
            cat("\n=== Missing Values === \n")
            cat("------------------------------------------------\n")

            
            print(kable(dt.values.missing[missing > 0],
                        format = "latex",
                        booktabs = TRUE,
                        longtable = TRUE) %>% kable_styling(latex_options = "repeat_header"))


            cat("\n------------------------------------------------\n")
            cat("\n=== Present Values === \n")
            cat("------------------------------------------------\n")

            
            print(kable(dt.values.present[present < nrow(x)],
                        format = "latex",
                        booktabs = TRUE,
                        longtable = TRUE) %>% kable_styling(latex_options = "repeat_header"))
      
        }
    


    list.return <- list(missing = dt.values.missing,
                        present = dt.values.present)
    

    return(list.return)
    

}
