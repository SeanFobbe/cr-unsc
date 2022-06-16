#'## f.empty.list.NA: Replaces empty elements in list with "NA"

f.list.empty.NA <- function(x) if (length(x) == 0) NA_character_ else paste(x, collapse = " ")