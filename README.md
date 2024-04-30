# Corpus of Resolutions: UN Security Council




## Overview

This code in the [R programming language](https://en.wikipedia.org/wiki/R_(programming_language)) downloads and processes the full set of resolutions, drafts and meeting records rendered by the United Nations Security Council (UNSC) as published by the [UN Digital Library](https://digitallibrary.un.org/) into a rich and structured human- and machine-readable dataset. It is the basis for the **Corpus of Resolutions: UN Security Council (CR-UNSC)**.

All data sets created with this script will always be hosted permanently open access and freely available at Zenodo, the scientific repository of CERN. Each version is uniquely identified with a persistent Digitial Object Identifier (DOI), the *Version DOI*. The newest version of the data set will always available via the link of the *Concept DOI*: https://doi.org/10.5281/zenodo.7319781


## Features

- 84 Variables
- Resolution texts in all six official UN languages (English, French, Spanish, Arabic, Chinese, Russian)
- Draft texts of resolutions in English
- Meeting record texts in English
- Citation data as GraphML (UNSC-to-UNSC and UNSC-to-UNGA resolutions)
- Bibliographic database in BibTeX/OSCOLA format for e.g. Zotero, Endnote and Jabref
- Extensive Codebook to explain the uses of the dataset
- Compilation Report and Quality Assurance Report explain construction and validation of the data set
- Pre-built diagrams for all purposes (PDF for printing, PNG for web)
- Open and platform independent file formats (CSV, PDF, TXT, GraphML)
- Software is version controlled with Docker
- Publication of full data set (Open Data)
- Publication of full source code (Open Source)
- Data published under Public Domain waiver (CC Zero 1.0)
- Software published under GNU General Public License Version 3 (GNU GPL v3)
- Secure cryptographic signatures for release files


## Functionality
 
The pipeline will produce the following results and store them in the  `output/` folder:

- Codebook
- Compilation Report
- Quality Assurance Report
- ZIP archive containing the main data set as a CSV file
- ZIP archive containing the only metadata of the main data set as a CSV file
- ZIP archive containing citation data and metadata as a GraphML file
- ZIP archive containing all resolution texts as TXT files (OCR and extracted)
- ZIP archive containing all resolution texts as PDF files (OCR and extracted)
- ZIP archive containing all draft texts as PDF files (OCR and extracted)
- ZIP archive containing all meeting record texts as PDF files (OCR and extracted)
- ZIP archive containing the full source code
- ZIP archive containing all intermediate pipeline results ("targets")

 The integrity and veracity of each ZIP archive is documented with cryptographically secure hash signatures (SHA2-256 and SHA3-512). Hashes are stored in a separate CSV file created during the data set compilation process.


## System Requirements

- The reference data sets were compiled on a Debian host system. Running the Docker config on an SELinux system like Fedora may require some modifications in the Docker Compose config.
- 50 GB space on hard drive
- Multi-core CPU recommended. We used 8 cores/16 threads to compile the reference data sets. Standard config will use all cores on a system. This can be fine-tuned in the config file.


## Instructions


### Step 1: Prepare Project Folder


Copy the Github repository into an empty (!) folder, for example by:

```
$ git clone https://github.com/seanfobbe/cr-unsc
```

Please always use an *empty* folder for creating the data set. The code will delete and re-create certain subfolders without requesting additional permission.



### Step 2: Create Docker Image

The Dockerfile contains automated instructions to create a full operation system with all necessary dependencies. To create the image from the Dockerfile, please execute: 

```
$ bash docker-build-image.sh
```


### Step 3: Compile Dataset

If you have previously compiled the data set, whether successfuly or not, you can delete all output and temporary files by executing:

```
$ Rscript delete_all_data.R
```

You can compile the full data set by executing:


```
$ bash docker-run-project.sh
```




### Results

Once the pipeline has concluded successfuly, the data set and all results are now stored in the folder `output/`.




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
> tar_meta()      # Show all metadata
> tar_meta(fields = "warnings", complete_only = TRUE)  # Warnings
> tar_meta(fields = "error", complete_only = TRUE)  # Errors
> tar_meta(fields = "seconds")  # Runtime for each target
```



## Project Structure

This structural analysis of the project describes its most important and version-controlled components. During compilation the pipeline will create further folders in which intermediate results are stored (`files`, `temp/` `analysis` and `output/`). Final results are stored in the folder `output/`.


``` 
.
├── buttons                    # Buttons (for tex title pages)
├── CHANGELOG.md               # Narrative summary of changes
├── config.toml                # Primary configuration file
├── data                       # Data sets that are imported by the pipeline
├── delete_all_data.R          # Clear all results for fresh run
├── docker-build-image.sh      # Build Docker image
├── docker-compose.yaml        # Docker container runtime configuration
├── Dockerfile                 # Instructions on how to create Docker image
├── docker-run-project.sh      # Build Docker image and run full project
├── etc                        # Additional configuration files
├── functions                  # Key pipeline components
├── gpg                        # Personal Public GPG-Key for Seán Fobbe
├── instructions               # Instructions on how to manually handle data
├── LICENSE                    # License for the software
├── pipeline.Rmd               # Master file for data pipeline
├── README.md                  # Usage instructions
├── reports                    # Report templates
├── run_project.R              # Run entire pipeline
└── tex                        # LaTeX templates


``` 

