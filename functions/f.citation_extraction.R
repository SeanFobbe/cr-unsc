


f.citation_extraction <- function(text){


    target <- stringi::stri_extract_all(text, regex = "[0-9]{1,4} \\([0-9]{4}\\)")

    source <- paste0(dt.final$res_no, " (", dt.final$year, ")")
    
    bind <- mapply(cbind, source, target)

    bind2 <- lapply(bind, as.data.table)

    dt <- rbindlist(bind2)



g  <- igraph::graph.data.frame(dt,
                               directed = TRUE)


ggraph(g,) + 
    geom_edge_diagonal(colour = "grey")+
    geom_node_point()+
    geom_node_text(aes(label = name),
                   size = 2,
                   repel = TRUE)+
    theme_void()
    
    

res[[1]]

out[[1]]
    
    
str(dt.final)
    }
