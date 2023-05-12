f.tar_pdf_ocr <- function(x,
                          dpi = 300,
                          lang = "eng",
                          crop.firstpage = 0,
                          crop.lastpage = 0,
                          output = "pdf txt",
                          skip = TRUE,
                          dir.out.pdf = "pdf_tesseract",
                          dir.out.txt = "txt_tesseract",
                          quiet = TRUE,
                          jobs = round(parallel::detectCores() / 4 )){

    
    ## Delete temp dir, if it exists
    unlink("temp_tesseract", recursive = TRUE)
    
    ## Create directories
    dir.create("temp_tesseract", showWarnings = FALSE)
    dir.create(dir.out.pdf, showWarnings = FALSE)
    dir.create(dir.out.txt, showWarnings = FALSE)



    ## Define Workload


    if(skip == TRUE){
        
        pdf <- gsub("\\.pdf",
                    "_TESSERACT\\.pdf",
                    basename(x),
                    ignore.case = TRUE)

        txt <- gsub("\\.pdf",
                    "_TESSERACT\\.txt",
                    basename(x),
                    ignore.case = TRUE)



        if ((grepl("pdf", output) == TRUE) && (grepl("txt", output) == TRUE)){

            check.pdf <- file.exists(file.path(dir.out.pdf, pdf))
            check.txt <- file.exists(file.path(dir.out.txt, txt))

            x <- x[!(check.pdf & check.txt)]
            
        }else{

            
            if (grepl("pdf", output) == TRUE){
                
                check.pdf <- file.exists(file.path(dir.out.pdf, pdf))
                x <- x[!check.pdf]

            }

            
            if (grepl("txt", output) == TRUE){
                
                check.txt <- file.exists(file.path(dir.out.txt, txt))
                x <- x[!check.txt]
                
            }
           
            
        }
        
    }
    
    
    ## Set parallel futures
    plan(multisession,
         workers = jobs)
    
    
    ## Run Tesseract

    if (length(x) > 0){
        
    f.future_pdf_ocr(x = x,
                     dpi = dpi,
                     lang = lang,
                     crop.firstpage = crop.firstpage,
                     crop.lastpage = crop.lastpage,
                     output = output,
                     skip = skip,
                     dir.out = "temp_tesseract",
                     quiet = quiet)

    }
        

    ## Sort files
    files.pdf <- list.files("temp_tesseract", pattern = "\\.pdf", full.names = TRUE)
    files.txt <- list.files("temp_tesseract", pattern = "\\.txt", full.names = TRUE)

    invisible(file.rename(files.pdf, file.path(dir.out.pdf, basename(files.pdf))))
    invisible(file.rename(files.txt, file.path(dir.out.txt, basename(files.txt))))


    ## Delete temp dir
    unlink("temp_tesseract", recursive = TRUE)

    ## Define return value
    files.out <- c(list.files(dir.out.pdf, full.names = TRUE),
                   list.files(dir.out.txt, full.names = TRUE))

    return(files.out)

}









f.future_pdf_ocr <- function(x,
                             dpi = 300,
                             lang = "eng",
                             crop.firstpage = 0,
                             crop.lastpage = 0,
                             output = "pdf txt",
                             skip = TRUE,
                             dir.out = ".",
                             quiet = TRUE){

    ## Timestamp: Begin
    begin <- Sys.time()

    ## Intro messages
    if(quiet == FALSE){
        message(paste("Begin at:", begin.extract))
        message(paste("Processing", length(x), "PDF files."))
    }

    
    ## Create Directory
    dir.create(dir.out, showWarnings = FALSE, recursive = TRUE)

    
    
    ## Define Workload


    if(skip == TRUE){
        
        pdf <- gsub("\\.pdf",
                    "_TESSERACT\\.pdf",
                    basename(x),
                    ignore.case = TRUE)

        txt <- gsub("\\.pdf",
                    "_TESSERACT\\.txt",
                    basename(x),
                    ignore.case = TRUE)



        if ((grepl("pdf", output) == TRUE) && (grepl("txt", output) == TRUE)){

            check.pdf <- file.exists(file.path(dir.out, pdf))
            check.txt <- file.exists(file.path(dir.out, txt))

            x <- x[!(check.pdf & check.txt)]
            
        }else{

            
            if (grepl("pdf", output) == TRUE){
                
                check.pdf <- file.exists(file.path(dir.out, pdf))
                x <- x[!check.pdf]

            }

            
            if (grepl("txt", output) == TRUE){
                
                check.txt <- file.exists(file.path(dir.out, txt))
                x <- x[!check.txt]
                
            }
            

            
        }
        
    }
    

    
    ## Run Tesseract

    if (length(x) > 0){
        
        results <- future.apply::future_lapply(x,
                                               pdf_ocr_single,
                                               dpi = dpi,
                                               lang = lang,
                                               crop.firstpage = crop.firstpage,
                                               crop.lastpage = crop.lastpage,
                                               output = output,
                                               dir.out = dir.out,
                                               future.seed = TRUE)
        

        results <- unlist(results)


    }
    
    
    ## Timestamp: End
    end <- Sys.time()

    ## Duration
    duration <- end - begin

    
    ## Outro messages
    if(quiet == FALSE){
        message(paste0("Successfully processed ",
                       sum(results == 0),
                       " PDF files. ",
                       sum(results == 1),
                       " PDF files failed."))
        
        message(paste0("Runtime was ",
                       round(duration,
                             digits = 2),
                       " ",
                       attributes(duration)$units,
                       "."))
        
        message(paste0("Ended at: ",
                       end))
    }

}









pdf_ocr_single <- function(x,
                           dpi = 300,
                           lang = "eng",
                           crop.firstpage = 0,
                           crop.lastpage = 0,
                           output = "pdf txt",
                           dir.out = "."){

    tryCatch({
        
        filename.out <- gsub("\\.pdf",
                             "_TESSERACT",
                             x,
                             ignore.case = TRUE)

        filename.out <- file.path(dir.out,
                                  basename(filename.out))

        
        ## Convert to TIFF
        filename.tiff <- f.convert_crop(x = x,
                                        dir.out = ".",
                                        tempfile = TRUE,
                                        dpi = dpi,
                                        crop.firstpage = crop.firstpage,
                                        crop.lastpage = crop.lastpage)
        
        
        ## Run Tesseract
        system2("tesseract",
                paste(filename.tiff,
                      filename.out,
                      "-l",
                      lang,
                      output))
        
        unlink(filename.tiff)

        invisible(filename.out)

    },
    
    error = function(cond) {
        return(NA)}
    )

    
}









#' f.convert_crop    

#' @param x String. The name of the PDF file to be converted to TIFF.
#' @param dpi Integer. The density to convert the image at. Defaults to 300.
#' @param crop.firstpage Numeric. The proportion of the first page to crop. Crop begins at the top of the page. Accepts values between 0 and 1, but not 1. Defaults to 0. Example: 0.2 will crop 20% off the top of the first page.
#' @param crop.lastpage Numeric. The proportion of the last page to crop. Crop begins at the bottom of the page. Accepts values between 0 and 1, but not 1. Defaults to 0. Example: 0.2 will crop 20% off the bottom of the last page.
#' @param dir.out String. The output directory. Defaults to working directory. Will be ignored if tempfile = TRUE.
#' @param tempfile Logical. Output system-bound temporary files with random names instead of a modified version of the original filename? Useful if used in conjunction with Tesseract and tempfs. Defaults to FALSE.
#'
#' @return String. Returns path to output TIFF.
    




f.convert_crop <- function(x,
                           dpi = 300,
                           crop.firstpage = 0,
                           crop.lastpage = 0,                               
                           dir.out = ".",
                           tempfile = FALSE){

    
    if(crop.firstpage == 1 || crop.lastpage == 1){
        
        stop("You cannot crop an entire page. Remove it instead.")
        
    }
    

    img <- image_read_pdf(x,
                          pages = NULL,
                          density = dpi)



    info <- image_info(img)
    index.lastpage <- nrow(info)

    width.firstpage  <-  info[1,]$width
    height.firstpage <- info[1,]$height

    width.lastpage <- info[index.lastpage,]$width
    height.lastpage <- info[index.lastpage,]$height


    

    if (crop.firstpage != 0 || crop.lastpage != 0){


        
        ## Case 1: Crop for one or more pages
        
        if (index.lastpage > 1){

            ## Crop first page

            height.firstpage.new <- round(height.firstpage * (1 - crop.firstpage))
            
            dims.firstpage <- geometry_area(width = width.firstpage,
                                            height = height.firstpage.new,
                                            x_off = 0,
                                            y_off = 0)



            firstpage <- image_crop(img[1],
                                    dims.firstpage,
                                    gravity = "South")

            

            ## Crop last page

            height.lastpage.new <- round(height.lastpage * (1 - crop.lastpage))
            
            dims.lastpage <- geometry_area(width = width.lastpage,
                                           height = height.lastpage.new,
                                           x_off = 0,
                                           y_off = 0)


            lastpage <- image_crop(img[index.lastpage],
                                   dims.lastpage,
                                   gravity = "North")



            if(index.lastpage == 2){
                
                img.final <- c(firstpage, lastpage)
                
            }else{
                
                middlepages <- img[-c(1, index.lastpage)]
                
                img.final <- c(firstpage, middlepages, lastpage)
                
            }
            
            
            ## Case 2: Crop for single page
        }else{


            ## Top 
            height.firstpage.new <- round(height.firstpage * (1 - crop.firstpage))

            
            dims.firstpage <- geometry_area(width = width.firstpage,
                                            height = height.firstpage.new,
                                            x_off = 0,
                                            y_off = 0)



            singlepage <- image_crop(img[1],
                                     dims.firstpage,
                                     gravity = "South")



            info.singlepage <- image_info(singlepage)

            height.singlepage.postcrop  <-  info.singlepage[1,]$height
            

            ## Bottom
            height.lastpage.new <- height.singlepage.postcrop - round(height.firstpage * crop.lastpage)


            dims.lastpage <- geometry_area(width = width.firstpage,
                                           height = height.lastpage.new,
                                           x_off = 0,
                                           y_off = 0)


            singlepage <- image_crop(singlepage,
                                     dims.lastpage,
                                     gravity = "North")
            


            
            img.final <- singlepage
            
            

        }


    }else{

        img.final  <- img

    }




    if(tempfile == TRUE){

        filename.new <- tempfile(pattern = "tesseract", fileext = ".tiff")

    }else{
        filename.new <- file.path(dir.out,
                                  paste0(tools::file_path_sans_ext(basename(x)), ".tiff"))
        }
    


    ## Write image
    image_write(
        img.final,
        path = filename.new,
        format = "tiff",
        quality = NULL,
        depth = 8,
        density = dpi,
        compression = "LZW")



    
    return(filename.new)


}

