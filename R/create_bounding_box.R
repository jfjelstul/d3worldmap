###########################################################################
# Josh Fjelstul, Ph.D.
# 3dworldmap R package
###########################################################################

create_bounding_box <- function(map_data) {
  
  # create a bounding box
  bounding_box <- sf::st_bbox(map_data)
  
  # get bounding box from data
  bounding_box_data <- sf::st_as_sfc(bounding_box)
  
  # get bounding box coordinates
  matrix <- bounding_box_data[[1]][[1]]
  xmin <- min(matrix[,1])
  xmax <- max(matrix[,1])
  ymin <- min(matrix[,2])
  ymax <- max(matrix[,2])

  # new limits
  out <- list(
    xmin = xmin,
    xmax = xmax,
    ymin = ymin,
    ymax = ymax
  )
  
  # return
  return(out)
}

###########################################################################
# end R script
###########################################################################
