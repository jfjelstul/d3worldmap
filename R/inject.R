###########################################################################
# Josh Fjelstul, Ph.D.
# 3dworldmap R package
###########################################################################

inject <- function(x, a, b, color = FALSE) {
  if(color) {
    x <- stringr::str_replace(x, stringr::str_c("[{]+", a, "[}]+"), convert_color(b)) 
  } else {
    x <- stringr::str_replace(x, stringr::str_c("[{]+", a, "[}]+"), as.character(b))
  }
  return(x)
}

###########################################################################
# end R script
###########################################################################