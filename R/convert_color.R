###########################################################################
# Josh Fjelstul, Ph.D.
# 3dworldmap R package
###########################################################################

convert_color <- function(color) {

  # if rgb
  if(length(color) == 3 | length(color) == 4) {
    
    # if no alpha
    if(length(color) == 3) {
      
      # if max value is 1
      if(color[1] <= 1 & color[2] <= 1 & color[3] <= 1) {
        color <- rgb(color[1], color[2], color[3], 1, maxColorValue = 1)  
      }
      
      # if max value is 255
      else {
        color <- rgb(color[1], color[2], color[3], 255, maxColorValue = 255) 
      }
    }
  
    # if alpha
    else {
      
      # if max value is 1
      if(color[1] <= 1 & color[2] <= 1 & color[3] <= 1 & color[4] <= 1) {
        color <- rgb(color[1], color[2], color[3], color[4], maxColorValue = 1)  
      }
      
      # if max value is 255
      else {
        color <- rgb(color[1], color[2], color[3], color[4], maxColorValue = 255) 
      }
    }
  }
    
  # if hex
  else if(length(color) == 1){
    
    if(!stringr::str_detect(color, "^(#)?([A-Z0-9]{6}|[A-Z0-9]{8})$")) {
      stop("please enter a valid RGB or HEX color")
    }
    
    # if 6 digits, convert to 8 digits
    if(stringr::str_detect(color, "^(#)?[A-Z0-9]{6}$")) {
      color <- stringr::str_c(color, "FF")
    }
    
    # add a # if needed
    if(!stringr::str_detect(color, "^#")) {
      color <- stringr::str_c("#", color)
    }
  }
  
  # throw error
  else {
    stop("please enter a valid RGB or HEX color")
  }
  
  # return color
  return(color)
}

# examples
# convert_color(c(1, 1, 1)) # RGB, no alpha, max 1
# convert_color(c(1, 1, 1, 1)) # RGB, alpha, max 1
# convert_color(c(255, 255, 255)) # RGB, no alpha, max 255
# convert_color(c(255, 255, 255, 255)) # RGB, alpha, max 255
# convert_color("#FFFFFF") # hex, no alpha, with #
# convert_color("#FFFFFFFF") # hex, alpha, with #
# convert_color("FFFFFF") # hex, no alpha, without #
# convert_color("FFFFFFFF") # hex, alpha, without #

###########################################################################
# end R script
###########################################################################
