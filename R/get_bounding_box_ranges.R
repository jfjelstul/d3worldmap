###########################################################################
# Josh Fjelstul, Ph.D.
# 3dworldmap R package
###########################################################################

get_bounding_box_ranges <- function(bounding_box) {
  
  # ranges
  x <- bounding_box$xmax - bounding_box$xmin
  y <- bounding_box$ymax - bounding_box$ymin
  
  # output
  out <- list(
    x = x,
    y = y
  )
  
  # return
  return(out)
}

###########################################################################
# end R script
###########################################################################
