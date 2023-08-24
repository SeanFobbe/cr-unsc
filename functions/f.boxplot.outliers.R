#'## f.boxplot.outliers: Calculate boxplot outliers for use with logarithmic axes in ggplot2
#' When plotting a boxplot on a logarithmic scale ggplot2 incorrectly performs the statistical transformation first before calculating the boxplot statistics. While median and quartiles are based on ordinal position the inter-quartile range differs depending on when statistical transformation is performed.
#'
#' This function calculates outliers for use with ggplot2's stat_summary. Solution is based on this SO question: https://stackoverflow.com/questions/38753628/ggplot-boxplot-length-of-whiskers-with-logarithmic-axis

f.boxplot.outliers = function(x) {
    
    data.frame(y = log10(boxplot.stats(10^x)[["out"]]))
    
}
