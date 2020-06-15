###########################################################################
# Josh Fjelstul, Ph.D.
# 3dworldmap R package
###########################################################################

expand_bounding_box <- function(margin, height, width, bounding_box) {
  
  # bounding box ranges
  bounding_box_ranges <- get_bounding_box_ranges(bounding_box)
  
  # projected map units per px
  if(!is.null(height)) {
    units_per_px <- bounding_box_ranges$y / height
  } else if(!is.null(width)) {
    units_per_px <- bounding_box_ranges$x / width
  } else {
    stop("width or height need to be specified")
  }
  
  # units_per_px <- bounding_box_ranges$y / height 

  # calculate new margin
  margin_px <- units_per_px * margin
  
  # expand bounding box
  bounding_box$xmax <- bounding_box$xmax + margin_px
  bounding_box$xmin <- bounding_box$xmin - margin_px
  bounding_box$ymax <- bounding_box$ymax + margin_px
  bounding_box$ymin <- bounding_box$ymin - margin_px
  
  # return
  return(bounding_box)
}

###########################################################################
# end R script
###########################################################################
