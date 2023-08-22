# Corpus of Resolutions: UN Security Council




## Overview

This code in the [R programming language](https://en.wikipedia.org/wiki/R_(programming_language)) downloads and processes the full set of resolutions, drafts and meeting records rendered by the United Nations Security Council (UNSC) as published on <https://digitallibrary.un.org/?ln=en> into a rich and structured human- and machine-readable data set. It is the basis for the **Corpus of Resolutions: UN Security Council (CR-UNSC)**.

All data sets created with this script will always be hosted permanently open access and freely available at Zenodo, the scientific repository of CERN. Each version is uniquely identified with a persistent Digitial Object Identifier (DOI), the *Version DOI*. The newest version of the data set will always available via the link of the *Concept DOI*: https://doi.org/10.5281/zenodo.7319781




## Functionality
 
The pipeline will produce the following results and store them in the folder `output`:

- ???
- ???

 The integrity and veracity of each ZIP archive is documented with cryptographically secure hash signatures (SHA2-256 and SHA3-512). Hashes are stored in a separate CSV file created during the data set compilation process.
 
Please refer to the Codebook regarding the relative merits of each variant. Unless you have very specific needs you should only use the variants denoted 'BEST' for serious work.
 




## System Requirements

- Compiled with Fedora Linux. Other Linux distributions may also work. Other operating systems not tested.
- 4 GB space on the hard drive
- Multi-core CPU recommended. We used 8 cores/16 threads to compile the reference data sets. Standard config will use all cores on a system. This can be fine-tuned in the config file.


## Instructions


### Schritt 1: Prepare Project Folder


Copy the Github repository into an empty (!) folder, for example by:

```
$ git clone https://github.com/seanfobbe/cr-unsc
```

Please always use an *empty* folder for creating the data set. The code will delete and re-create certain subfolders without requesting additional permission.



### Schritt 2: Install 'R' Programming Language

You must have installed the [R Programming Language](https://www.r-project.org/) und [OpenSSL](https://www.openssl.org/). Usually these are incldued with Fedora Linux, otherwise do:

```
$ sudo dnf install R openssl
```



### Schritt 3: Install 'renv'

Start an R session in the project folder. You should automatically be asked to install [renv](https://rstudio.github.io/renv/articles/renv.html). `renv` is a tool for the strict version control of R packages and is a key tool to ensure reproducibility.


### Schritt 4: Install R Packages

To use [renv](https://rstudio.github.io/renv/articles/renv.html) to install all R packages in the required version, execute in an R console:

```
> renv::restore()  # Execute in R console
```

*Warning:* it is not sufficient to have installed packages in your regular project library. You must do this again via [renv](https://rstudio.github.io/renv/articles/renv.html), even if by coincidence you have them installed exactly as required.



### Schritt 5: Install LaTeX


To compile the PDF reports you need a \LaTeX\ distribution. You can install a comprehensive \LaTeX -Distribution in Fedora like so.


```
$ sudo dnf install texlive-scheme-full
```

Alternatively, you can install the R package [tinytex](https://yihui.org/tinytex/), which is very economical and installs only the \LaTeX\ packages required for the project:

```
> install.packages("tinytex")  # Execute in R console
```

The \LaTeX\  distribution used for the reference data sets is `texlive-scheme-full`.





### Schritt 6: Compile Data Set


If you have compiled the dat set previously and wish to clean up all results for a fresh run, use the following script:

```
> source("delete_all_data.R") # Execute in R console
```


Den vollständigen Datensatz kompilieren Sie mit folgendem Befehl:

```
> source("run_project.R") # Execute in R console
```



### Results

Once the pipeline has concluded successfuly, the data set and all published results are now stored in the folder `output/`.




## Visualize Pipeline

After you have run `run_project.R` at least once you can use the commands below to visually inspect the pipeline.

```
> targets::tar_glimpse()     # Only data objects
> targets::tar_visnetwork()  # All objects, including functions
```





## Troubleshooting

The below commands are useful to troubleshoot the pipeline.

```
> tar_progress()  # Show progress and errors
> tar_meta()      # Show all metadata (can be subsetted)
> tar_meta(fields = "warnings", complete_only = TRUE)  # Warnings
> tar_meta(fields = "error", complete_only = TRUE)  # Errors
> tar_meta(fields = "seconds")  # Runtime for each target
```



## Project Structure

This structural analysis of the project describes the most important and version-controlled components. During compilation the pipeline will create further folders in which intermediate results are stored (`pdf/`, `txt/`, `temp/` `analysis` and `output/`). Final results are stored in the folder `output/`.

 
``` 
.
├── buttons                    # Buttons (for tex title pages)
├── CHANGELOG.md               # Narrative summary of changes
├── config.toml                # Primary configuration file
├── data                       # Data sets that are imported by the pipeline
├── delete_all_data.R          # Clear all results for fresh run
├── functions                  # Key pipeline components
├── gpg                        # Personal Public GPG-Key for Seán Fobbe
├── pipeline.Rmd               # Master file describing the pipeline
├── README.md                  # Usage instructions
├── renv                       # Version control, executables
├── renv.lock                  # Version control, version info
├── reports                    # Report templates
├── run_project.R              # Run entire pipeline
├── _targets_packages.R        # Version control, packages in pipeline
└── tex                        # LaTeX templates


``` 

