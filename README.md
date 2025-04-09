# ATTENTION: Project moved to Codeberg

Development of this project continues on Codeberg: https://codeberg.org/seanfobbe/cr-unsc

The GitHub repository will remain available as a read-only version.



# Corpus of Resolutions: UN Security Council




## Overview

This code in the [R programming language](https://en.wikipedia.org/wiki/R_(programming_language)) downloads and processes the full set of resolutions, drafts and meeting records rendered by the United Nations Security Council (UNSC), as published by the [UN Digital Library](https://digitallibrary.un.org/), into a rich and structured human- and machine-readable dataset. It is the basis for the **Corpus of Resolutions: UN Security Council (CR-UNSC)**.

All data sets created with this script will always be hosted permanently open access and freely available at Zenodo, the scientific repository of CERN. Each version is uniquely identified with a persistent Digitial Object Identifier (DOI), the *Version DOI*. The newest version of the data set will always available via the link of the *Concept DOI*: https://doi.org/10.5281/zenodo.7319780


## Features

- 82 Variables
- Resolution texts in all six official UN languages (English, French, Spanish, Arabic, Chinese, Russian)
- Draft texts of resolutions in English
- Meeting record texts in English
- URLs to draft texts in all other languages (French, Spanish, Arabic, Chinese, Russian)
- URLs to meeting record texts in all other languages (French, Spanish, Arabic, Chinese, Russian)
- Citation data as GraphML (UNSC-to-UNSC resolutions and UNSC-to-UNGA resolutions)
- Bibliographic database in BibTeX/OSCOLA format for e.g. Zotero, Endnote and Jabref
- Extensive Codebook to explain the uses of the dataset
- Compilation Report and Quality Assurance Report explain construction and validation of the data set
- Publication quality diagrams for teaching, research and all other purposes (PDF for printing, PNG for web)
- Open and platform independent file formats (CSV, PDF, TXT, GraphML)
- Software version controlled with Docker
- Publication of full data set (Open Data)
- Publication of full source code (Open Source)
- Free Software published under the GNU General Public License Version 3 (GNU GPL v3)
- Data published under Public Domain waiver (CC Zero 1.0)
- Secure cryptographic signatures for all files in version of record (SHA2-256 and SHA3-512)



## Functionality
 
The pipeline will produce the following results and store them in the  `output/` folder:

- Codebook as PDF
- Compilation Report as PDF
- Quality Assurance Report as PDF
- ZIP archive containing the main data set as a CSV file
- ZIP archive containing only the metadata of the main data set as a CSV file
- ZIP archive containing citation data and metadata as a GraphML file
- ZIP archive containing bibliographic data as a BIBTEX file
- ZIP archive containing all resolution texts as TXT files (OCR and extracted)
- ZIP archive containing all resolution texts as PDF files (original and English OCR)
- ZIP archive containing all draft texts as PDF files (original)
- ZIP archive containing all meeting record texts as PDF files (original)
- ZIP archive containing the full Source Code
- ZIP archive containing all intermediate pipeline results ("targets")

 The integrity and veracity of each ZIP archive is documented with cryptographically secure hash signatures (SHA2-256 and SHA3-512). Hashes are stored in a separate CSV file created during the data set compilation process.


## System Requirements

- The reference data sets were compiled on a Debian host system. Running the Docker config on an SELinux system like Fedora will require modifications of the Docker Compose config file.
- 40 GB space on hard drive
- Multi-core CPU recommended. We used 8 cores/16 threads to compile the reference data sets. Standard config will use all cores on a system. This can be fine-tuned in the config file.
- Given these requirements the runtime of the pipeline is approximately 40 hours.


## Instructions


### Step 1: Prepare Project Folder


Copy the Github repository into an empty (!) folder, for example by:

```
$ git clone https://github.com/seanfobbe/cr-unsc
```

Please always use an *empty* folder for creating the data set. The code will delete and re-create certain subfolders without requesting additional permission.



### Step 2: Create Docker Image

The Dockerfile contains automated instructions to create a full operating system with all necessary dependencies. To create the image from the Dockerfile, please execute: 

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



## Open Access Publications (Fobbe)

Website --- https://www.seanfobbe.com

Open Data --- https://zenodo.org/communities/sean-fobbe-data

Code Repository --- https://zenodo.org/communities/sean-fobbe-code

Regular Publications --- https://zenodo.org/communities/sean-fobbe-publications

 

## Contact

Did you discover any errors? Do you have suggestions on how to improve the data set? You can either post these to the Issue Tracker on GitHub or write me an e-mail at [fobbe-data@posteo.de](mailto:fobbe-data@posteo.de)
