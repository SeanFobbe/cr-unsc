#' f.regex_variables
#'
#' Create new variables by parsing text variable with regular expressions







f.regex_variables <- function(text){


    chapter7 <- grepl("Chapter VII", text)
    
    dt.return <- data.table(chapter7)



    
    return(dt.return)
    
}
