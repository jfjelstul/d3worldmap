###########################################################################
# Josh Fjelstul, Ph.D.
# 3dworldmap R package
###########################################################################

expand_bounding_box <- function(bounding_box, percent) {
  
  # get bounding box data
  bounding_box_data <- sf::st_as_sfc(bounding_box)
  
  # expand bounding box
  matrix <- bounding_box_data[[1]][[1]]
  xmin <- min(matrix[,1])
  xmax <- max(matrix[,1])
  ymin <- min(matrix[,2])
  ymax <- max(matrix[,2])
  
  # ranges
  x_range <- abs(xmax) - abs(xmin)
  y_range <- abs(ymax) - abs(ymin)
  
  # new limits
  out <- list(
    xmin = xmin - x_range * percent,
    xmax = xmax + x_range * percent,
    ymin = ymin - y_range * percent,
    ymax = ymax + y_range * percent
  )
  
  # return
  return(out)
}

###########################################################################
# end R script
###########################################################################
