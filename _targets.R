## Load Packages
library(targets)
library(tarchetypes)
library(RcppTOML)


## General Options

config <- parseTOML("CR-UNSC_Config.toml")

options(timeout = config$download$timeout)



## Define custom functions

lapply(list.files("functions", full.names = TRUE), source)




## Create Directories
dir.create("output")


## Datestamp
datestamp <- Sys.Date()


## Define Image Captions

caption <- paste("Fobbe | DOI:",
                 config$doi$data$version)


## Define Prefix for Output Files

prefix.files <- paste0(config$project$shortname,
                       "_",
                       datestamp)


## Define Prefix for Diagrams

prefix.figuretitle <- paste(config$project$shortname,
                            "| Version",
                            datestamp)





## Targets Options

tar_option_set(packages = c("fs",           # Improved File Handling
                            "zip",          # Improved ZIP Handling
                            "httr",         # HTTP Tools
                            "rvest",        # HTML/XML Extraction
                            "knitr",        # Professional Scientific Reporting
                            "kableExtra",   # Improved Kable Tables
                            "pdftools",     # Extract PDF Content
                            "ggplot2",      # Advanced Data Vizualization
                            "scales",       # Scaling of Diagrams
                            "data.table",   # Enhanced Data Transformations
                            "readtext",     # Read TXT files
                            "quanteda",     # Advanced Computer Linguistics
                            "future",       # Parallel Computing
                            "future.apply"))# Parallel Computing for Higher-order Base Functions



## End this file with a list of target objects.


list(tar_target(table.download.raw.file, "data/UNSC_Record-Pages_2636.csv"),

     tar_target(table.download.raw,
                fread(table.download.raw.file),
                format = "file")
     )

