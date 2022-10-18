
#' Parses UN Digital Library HTML record files and returns a data.table with relevant metadata for all records.

#' @param x String. A vector of paths to UN Digital Library HTML record files.

#' @return Data.table. A table of all relevant metadata. Includes the UNSC resolution number as unique key.


f.parse_records_res <- function(x){

    list <- lapply(x, f.record_metadata)

    dt <- rbindlist(list, fill = TRUE)

    res_no <- as.integer(tools::file_path_sans_ext(basename(x)))

    dt.final <- cbind(res_no, dt)

    return(dt.final)

}
