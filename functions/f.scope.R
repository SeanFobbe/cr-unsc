#' f.scope
#'
#' Defines scope of resolution numbers to be downloaded.
#'
#' @param limit Scalar Integer. Maximum resolution number to be downloaded.
#' @param debug.toggle Logical. Whether debugging mode is active and number of resolutions is a reduced random sample.
#' @param debug.sample Integer. The number of random resolutions to be sampled from the maximum limit.
#'
#' @return Integer. A set of resolution numbers to be included in the data set.



f.scope <- function(limit,
                    debug.toggle,
                    debug.sample){


    res.no.full <- 1:limit

    if (debug.toggle == TRUE){

        res.no.full <- sort(sample(res.no.full, debug.sample))
    }

    
    return(res.no.full)

    
}
