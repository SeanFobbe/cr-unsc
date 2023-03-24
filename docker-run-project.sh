#!/bin/bash
set -e

time docker build -t cr-unsc:4.2.2 .

time docker-compose run --rm cr-unsc Rscript run_project.R
