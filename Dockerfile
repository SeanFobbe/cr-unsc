FROM rocker/verse:4.2.2

RUN R -q -e 'install.packages(c("targets", "tarchetypes"))'

CMD "R"