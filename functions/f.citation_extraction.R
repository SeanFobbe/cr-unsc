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
    dt$source <- as.integer(sub("([0-9]{1,5}) \\([0-9]{4}\\)", "\\1", dt$source))
    dt$target <- as.integer(gsub("([0-9]{1,5}) \\([0-9]{4}\\)", "\\1", dt$target))
    
    ## Remove implausible citations (res cannot cite later resolutions!)
    dt <- dt[!(dt$source <= dt$target)]
    dt <- dt[!(dt$source == 0)]
    dt <- dt[!(dt$target == 0)]

    ## Create Graph Object
    g  <- igraph::graph.data.frame(dt,
                                   directed = TRUE)

    
    ## Convert Parallel Edges to Weights
    
    igraph::E(g)$weight <- 1
    g <- igraph::simplify(g, edge.attr.comb = list(weight = "sum"))


    ## Extract vertex names
    g.names <- as.integer(igraph::vertex_attr(g, "name"))


    ## Fill missing resolutions
    dt.missing <- data.table(res_no = setdiff(g.names, dt.final$res_no))
    dt.fill <- rbind(dt.final, dt.missing, fill = TRUE)
    
    ## Match metadata to graph
    match <- match(g.names, dt.fill$res_no)
    dt.graphmeta <- dt.fill[match]

    
    ## Set Vertex Attributes (single)
    ## g <- igraph::set_vertex_attr(g,
    ##                              "symbol",
    ##                              index = match,
    ##                              dt.graphmeta[match]$symbol)

    
    ## Set Vertex Attributes (all)

    varnames <- names(dt.graphmeta)
    varnames <- grep("text|url", varnames, invert = TRUE, value = TRUE)
    
    for(i in varnames){
    g <- igraph::set_vertex_attr(graph = g,
                                 name = i,
                                 value = unname(unlist(dt.graphmeta[, ..i])))

    }

    return(g)


}


## DEBUGGING

##tar_load(dt.final)
##library(data.table)
## data.frame(V(g)$name[1:50], V(g)$symbol[1:50], V(g)$title[1:50])

    ## sum(is.na(dt.graphmeta$language))
    ## sum(is.na(V(g)$language))
    ## sum(is.na(unname(unlist(dt.graphmeta[match, ..i]))))
    ## sum(is.na(dt.graphmeta[match]$symbol))


    ## sum(is.na(unname(unlist(dt.graphmeta[match,"symbol"]))))
    



## ggraph(g,) + 
##     geom_edge_diagonal(colour = "grey")+
##     geom_node_point()+
##     geom_node_text(aes(label = name),
##                    size = 2,
##                    repel = TRUE)+
##     theme_void()
    
    

## res[[1]]

## out[[1]]
    
