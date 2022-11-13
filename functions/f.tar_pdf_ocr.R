


f.tar_pdf_ocr <- function(x,
                          dpi = 300,
                          lang = "eng",
                          output = "pdf txt",
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

    ## Set parallel futures
    plan(multicore,
         workers = jobs)


    ## Run tesseract
    f.future_pdf_ocr(x = x,
                     dpi = dpi,
                     lang = lang,
                     output = output,
                     outputdir = "temp_tesseract",
                     quiet = quiet)


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
