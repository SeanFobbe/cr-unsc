#' f.citation_extraction
#'
#' Extract citations and convert to igraph object.
#'
#' @param dt.final Data.table. The final data set.
#' @return Igraph object. All internal citations as a graph object.




f.citation_extraction <- function(dt.final){


    ## Extract outgoing UNSC citations, example: "S/RES/2672 (2023)"
    
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
    dt <- dt[source >= target]
    dt <- dt[source != 0]
    dt <- dt[target != 0]


    
    
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










    ## Extract outgoing UNGA citations (Roman short): A/RES/1514(XV)
    ## NONE TO BE FOUND
    
    ## target <- stringi::stri_extract_all(dt.final$text,
    ##                                     regex = "A\\/RES\\/[0-9]+\\s*\\([IVX]+\\)",
    ##                                     case_insensitive = TRUE)


    
    
    ## todo: emergency sesions: A/RES/997(ES-I), A/RES/ES-11/1, ", "22 A (I)"
    

    unga.roman.long <- "[Gg]eneral\\s*[Aa]ssembly\\s*[Rr]esolution\\s*[0-9]{1,5}\\s*\\([IVXLC]+\\)"
    unga.arabic.short <- "A\\/RES\\/[0-9]+\\/[0-9]+"
    unga.arabic.long <- "[Gg]eneral\\s*[Aa]ssembly\\s*[Rr]esolution\\s*[0-9]{1,5}\\/[0-9]{1,5}"

    unga.regex.full <- paste0(paste0("(",
                                     c(unga.roman.long,
                                       unga.arabic.short,
                                       unga.arabic.long),
                                     ")"),
                              collapse = "|")

    ## Run extraction
    target <- stringi::stri_extract_all(dt.final$text,
                                        regex = unga.regex.full,
                                        case_insensitive = TRUE)

    
    ## unique(unlist(target))



    
    ## Bind
    bind <- mapply(cbind, source, target)
    bind2 <- lapply(bind, as.data.table)
    
    dt.unga <- rbindlist(bind2)
    setnames(dt.unga, new = c("source", "target"))

    ## Reduce source to numeric value
    dt.unga$source <- as.integer(sub("([0-9]{1,5}) \\([0-9]{4}\\)", "\\1", dt.unga$source))
    
    ## Remove resolutions without UNGA citations
    dt.unga <- dt.unga[!is.na(target)]

    
    ## Standardize
    temp <- gsub("\\s+", " ", dt.unga$target)
    temp <- gsub("[Gg]eneral [Aa]ssembly [Rr]esolution ", "A/RES/", temp)
    dt.unga$target <- gsub("res", "RES", temp,  ignore.case = TRUE)

    


    ## Create Graph Object
    g.unga  <- igraph::graph.data.frame(dt.unga,
                                        directed = TRUE)




    ## Combine UNSC and UNGA graphs

    g.all <- union(g, g.unga)



    
    return(g.all)


}


## DEBUGGING

##tar_load(dt.final)
##library(data.table)
## library(igraph)
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
    
