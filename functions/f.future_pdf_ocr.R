





f.future_pdf_ocr <- function(x,
                             dpi = 300,
                             lang = "eng",
                             output = "pdf txt",
                             outputdir = NULL,
                             quiet = TRUE){

    ## Timestamp: Begin
    begin.extract <- Sys.time()

    ## Intro messages
    if(quiet == FALSE){
        message(paste("Begin at:", begin.extract))
        message(paste("Processing", length(x), "PDF files."))
    }

    ## Run Tesseract
    results <- future.apply::future_lapply(x,
                                           pdf_ocr_single,
                                           dpi = dpi,
                                           lang = lang,
                                           output = output,
                                           outputdir = outputdir,
                                           future.seed = TRUE)
    

    results <- unlist(results)


    
    
    ## Timestamp: End
    end.extract <- Sys.time()

    ## Duration
    duration.extract <- end.extract - begin.extract

    
    ## Outro messages
    if(quiet == FALSE){
        message(paste0("Successfully processed ",
                       sum(results == 0),
                       " PDF files. ",
                       sum(results == 1),
                       " PDF files failed."))
        
        message(paste0("Runtime was ",
                       round(duration.extract,
                             digits = 2),
                       " ",
                       attributes(duration.extract)$units,
                       "."))
        
        message(paste0("Ended at: ",
                       end.extract))
    }

}






pdf_ocr_single <- function(x,
                           dpi = 300,
                           lang = "eng",
                           output = "pdf txt",
                           outputdir = NULL){
    
    ## Define names
    name.tiff <- gsub("\\.pdf",
                      "\\.tiff",
                      x,
                      ignore.case = TRUE)
    
    name.out <- gsub("\\.pdf",
                     "_TESSERACT",
                     x,
                     ignore.case = TRUE)

    ## Alternate Folder Option
    if (!is.null(outputdir)){
        
        name.out <- file.path(outputdir,
                             basename(name.out))
        
        }
    
    ## Convert to TIFF
    system2("convert",
            paste("-density",
                  dpi,
                  "-depth 8 -compress LZW -strip -background white -alpha off",
                  x,
                  name.tiff))



    ## Run Tesseract
    system2("tesseract",
            paste(name.tiff,
                  name.out,
                  "-l",
                  lang,
                  output))
    
    unlink(name.tiff)

    
}
