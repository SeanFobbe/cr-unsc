
data.table(res_nos, recordlinks_url)[sample(50, 5)]




url <- "https://digitallibrary.un.org/record/111952" # res 37

html <- read_html(url)

# add: lik to draft res and meeting record

extract_download_undl <- function(html){

    # sample link:  "/record/111952/files/S_RES_37%281947%29-ES.pdf"
    
    links <- html_nodes(html, "a") %>% html_attr('href')

    pdf.relative <- unique(grep("/record/[0-9]+/files", links, value = TRUE))

    pdf.absolute <- paste0("https://digitallibrary.un.org",
                                pdf.relative)

    pdf.ar <- grep("AR\\.pdf", pdf.absolute, value = TRUE)
    pdf.en <- grep("EN\\.pdf", pdf.absolute, value = TRUE)
    pdf.es <- grep("ES\\.pdf", pdf.absolute, value = TRUE)
    pdf.fr <- grep("FR\\.pdf", pdf.absolute, value = TRUE)
    pdf.ru <- grep("RU\\.pdf", pdf.absolute, value = TRUE)
    pdf.zh <- grep("ZH\\.pdf", pdf.absolute, value = TRUE)


    value <- data.table(pdf.ar,
                        pdf.en,
                        pdf.es,
                        pdf.fr,
                        pdf.ru,
                        pdf.zh)
    
    return(value)
    
    }


extract_meta_undl <- function(html){

    nodes <- html_nodes(html, "[class='metadata-row']")
    title <- html_nodes(html, "[class='title col-xs-12 col-sm-3 col-md-2']") %>% html_text()
    title <- trimws(title)
    title <- gsub(" ", "_", title)
    content <- html_nodes(html, "[class='value col-xs-12 col-sm-9 col-md-10']") %>% html_text()
    content <- trimws(content)

    value <- data.table(title, content)
    value <- transpose(value, make.names = "title")

    pdf <- extract_download_undl(html)
    
    value <- cbind(value, pdf)
    
    return(value)
    
    }



extract_meta_undl(html)


fwrite(value, "test.csv")

