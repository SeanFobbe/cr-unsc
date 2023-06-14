#' f.citation_extraction
#'
#' Extract citations and convert to igraph object.
#'
#' @param dt.final Data.table. The final data set.
#' @return Igraph object. All internal citations as a graph object.




f.citation_extraction <- function(dt.final){


    ## Extract outgoing citations
    target <- stringi::stri_extract_all(dt.final$text,
                                        regex = "[0-9]{1,4} \\([0-9]{4}\\)")

    ## Define source resolutions
    source <- paste0(dt.final$res_no, " (", dt.final$year, ")")


    ## Bind source and target
    bind <- mapply(cbind, source, target)
    bind2 <- lapply(bind, as.data.table)

    dt <- rbindlist(bind2)
    setnames(dt, new = c("source", "target"))

    ## Remove resolutions without citations
    dt <- dt[!is.na(target)]

    ## Remove self-citations    
    dt <- dt[!(dt$source == dt$target)]

    ## Reduce to numeric value
    dt$source <- gsub("([0-9]{1,5}) \\([0-9]{4}\\)", "\\1", dt$source)
    dt$target <- gsub("([0-9]{1,5}) \\([0-9]{4}\\)", "\\1", dt$target)
    
    ## Remove implausible citations (res cannot cite later resolutions!)
    dt <- dt[!(dt$source <= dt$target)]

   


    ## Create Graph Object
    g  <- igraph::graph.data.frame(dt,
                                   directed = TRUE)


    return(g)
    

}


## DEBUGGING

##tar_load(dt.final)



## ggraph(g,) + 
##     geom_edge_diagonal(colour = "grey")+
##     geom_node_point()+
##     geom_node_text(aes(label = name),
##                    size = 2,
##                    repel = TRUE)+
##     theme_void()
    
    

## res[[1]]

## out[[1]]
    
