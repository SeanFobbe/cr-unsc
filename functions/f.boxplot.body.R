#'## f.boxplot.body: Calculate boxplot body for use with logarithmic axes in ggplot2
#' When plotting a boxplot on a logarithmic scale ggplot2 incorrectly performs the statistical transformation first before calculating the boxplot statistics. While median and quartiles are based on ordinal position the inter-quartile range differs depending on when statistical transformation is performed.
#'
#' This function calculates the boxplot body for use with ggplot2's stat_summary. Solution is based on this SO question: https://stackoverflow.com/questions/38753628/ggplot-boxplot-length-of-whiskers-with-logarithmic-axis

f.boxplot.body = function(x) {
    
    body = log10(boxplot.stats(10^x)[["stats"]])
    
    names(body) = c("ymin",
                   "lower",
                   "middle",
                   "upper",
                   "ymax")
    
    return(body)
    
} 
