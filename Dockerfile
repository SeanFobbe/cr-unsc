FROM rocker/verse:4.2.2

RUN sudo apt-get remove -y rstudio-server

RUN R -q -e 'install.packages(c("targets", "tarchetypes", "mgsub", "bib2df"))'

CMD "R"