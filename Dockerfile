FROM rocker/verse:4.2.2

RUN R -q -e 'install.packages(c("targets", "tarchetypes"))'

RUN sudo apt-get remove -y rstudio-server

CMD "R"