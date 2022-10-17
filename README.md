# Corpus of Resolutions: UN Security Council







## Visualize Pipeline

Once you have run `run_project.R` at least once you can use the commands below to visually inspect the pipeline.

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

