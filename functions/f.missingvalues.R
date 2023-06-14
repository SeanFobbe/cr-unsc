#' f.missingvalues
#'
#' Summarize missing values in data.frame or data.table
#'
#' @param x A data.frame or data.table to be inspected
#' @param dir.out Output directory to write CSV files to. Does not write CSV files if NULL (default).
#' @param prefix.files Optional prefix to add to files.




f.missingvalues <- function(x,
                            dir.out = NULL,
                            prefix.files = ""){



    vec.na <- is.na(x)
    
    values.missing <- apply(vec.na, 2, sum)
    values.present <- dt.final[,.N] - apply(vec.na, 2, sum)


    
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


    list.return <- list(dt.values.missing,
                        dt.values.present)
    

    return(list.return)
    

}
