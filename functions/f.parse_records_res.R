
#' Parses UN Digital Library HTML record files and returns a data.table with relevant metadata for all records.

#' @param x String. A vector of paths to UN Digital Library HTML record files.

#' @return Data.table. A table of all relevant metadata. Includes the UNSC resolution number as unique key.


f.parse_records_full <- function(x){

    list <- lapply(x, f.record_metadata)

    dt <- rbindlist(list, fill = TRUE)

    res_no <- as.integer(tools::file_path_sans_ext(basename(x)))

    dt.final <- cbind(res_no, dt)[order(res_no)]

    return(dt.final)

}





#' Parses UN Digital Library HTML record files and returns a data.table with URLs to full texts to each record.

#' @param x String. A vector of paths to UN Digital Library HTML record files.

#' @return Data.table. A table of all relevant URLs. Includes the UNSC resolution number as unique key.



f.parse_records_url <- function(x,
                                prefix = ""){

    list <- lapply(x, f.record_url, prefix = prefix)

    dt <- rbindlist(list, fill = TRUE)

    res_no <- as.integer(tools::file_path_sans_ext(basename(x)))

    dt.final <- cbind(res_no, dt)[order(res_no)]

    return(dt.final)

}



#' Parses UN Digital Library HTML record files and returns a data.table with relevant voting metadata for all records.

#' @param x String. A vector of paths to UN Digital Library HTML voting record files.

#' @return Data.table. A table of all relevant metadata. Includes the UNSC resolution number as unique key.


f.parse_records_voting <- function(x){

    list <- lapply(x, f.record_metadata_voting)

    dt <- rbindlist(list, fill = TRUE)

    res_no <- as.integer(tools::file_path_sans_ext(basename(x)))

    dt.final <- cbind(res_no, dt)[order(res_no)]

    return(dt.final)

}
