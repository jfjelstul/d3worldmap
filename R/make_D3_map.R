###########################################################################
# Josh Fjelstul, Ph.D.
# 3dworldmap R package
###########################################################################

# set working directory
setwd("~/Documents/d3worldmap/")

###########################################################################
# create formatting object
###########################################################################

formatting <- list(
  
  map_border_color = c(0.15, 0.15, 0.15),
  map_border_size = 1,
  map_background_color = c(0.97, 0.97, 0.97),
  
  feature_line_color = c(0.15, 0.15, 0.15),
  feature_fill_color = c(0.90, 0.90, 0.90),
  feature_line_size = 0.5,
  
  feature_line_color_hover = c(0.15, 0.15, 0.15),
  feature_fill_color_hover = c(0.80, 0.80, 0.80),
  feature_line_size_hover = 0.5,
  
  feature_line_color_select = c(0.15, 0.15, 0.15),
  feature_fill_color_select = c(0.70, 0.70, 0.70),
  feature_line_size_select = 0.5,
  
  feature_line_color_select_hover = c(0.15, 0.15, 0.15),
  feature_fill_color_select_hover = c(0.75, 0.75, 0.75),
  feature_line_size_select_hover = 0.5,
  
  tooltip_background_color = c(0, 0, 0, 0.7),
  tooltip_border_size = 0,
  tooltip_border_color = c(0.15, 0.15, 0.15),
  tooltip_font_size = 10,
  tooltip_font_color = c(1, 1, 1),
  tooltip_border_radius = 8,
  tooltip_padding_X = 16,
  tooltip_padding_Y = 8
)

###########################################################################
# map function
###########################################################################

make_D3_map <- function(file_prefix = "D3_map", single_file = TRUE, formatting = NULL, width = NULL, height = NULL) {
  
  # check for formatting
  if(is.null(formatting)) {
    stop("please supply a formatting object")
  }
  
  # prepare data
  geojson <- suppressWarnings(readLines("data/test.geojson"))
  
  ##################################################  
  # prepare CSS
  ##################################################
  
  # read in CSS template
  css <- readLines("data/templates/CSS-template.css")
  
  # map border
  css <- inject(css, "MAP_BORDER_COLOR", formatting$map_border_color, color = TRUE)
  css <- inject(css, "MAP_BORDER_SIZE", formatting$map_border_size)
  css <- inject(css, "MAP_BACKGROUND_COLOR", formatting$map_background_color, color = TRUE)
  
  # features (default)
  css <- inject(css, "FEATURE_LINE_COLOR", formatting$feature_line_color, color = TRUE)
  css <- inject(css, "FEATURE_FILL_COLOR", formatting$feature_fill_color, color = TRUE)
  css <- inject(css, "FEATURE_LINE_SIZE", formatting$feature_line_size)
  
  # features (hover)
  css <- inject(css, "FEATURE_LINE_COLOR_HOVER", formatting$feature_line_color_hover, color = TRUE)
  css <- inject(css, "FEATURE_FILL_COLOR_HOVER", formatting$feature_fill_color_hover, color = TRUE)
  css <- inject(css, "FEATURE_LINE_SIZE_HOVER", formatting$feature_line_size_hover)
  
  # features (select)
  css <- inject(css, "FEATURE_LINE_COLOR_SELECT", formatting$feature_line_color_select, color = TRUE)
  css <- inject(css, "FEATURE_FILL_COLOR_SELECT", formatting$feature_fill_color_select, color = TRUE)
  css <- inject(css, "FEATURE_LINE_SIZE_SELECT", formatting$feature_line_size_select)
  
  # features (select and hover)
  css <- inject(css, "FEATURE_LINE_COLOR_SELECT_HOVER", formatting$feature_line_color_select_hover, color = TRUE)
  css <- inject(css, "FEATURE_FILL_COLOR_SELECT_HOVER", formatting$feature_fill_color_select_hover, color = TRUE)
  css <- inject(css, "FEATURE_LINE_SIZE_SELECT_HOVER", formatting$feature_line_size_select_hover)
  
  # tooltip
  css <- inject(css, "TOOLTIP_BACKGROUND_COLOR", formatting$tooltip_background_color, color = TRUE)
  css <- inject(css, "TOOLTIP_BORDER_SIZE", formatting$tooltip_border_size)
  css <- inject(css, "TOOLTIP_BORDER_COLOR", formatting$tooltip_border_color, color = TRUE)
  css <- inject(css, "TOOLTIP_FONT_SIZE", formatting$tooltip_font_size)
  css <- inject(css, "TOOLTIP_FONT_COLOR", formatting$tooltip_font_color, color = TRUE)
  css <- inject(css, "TOOLTIP_BORDER_RADIUS", formatting$tooltip_border_radius)
  css <- inject(css, "TOOLTIP_PADDING_X", formatting$tooltip_padding_X)
  css <- inject(css, "TOOLTIP_PADDING_Y", formatting$tooltip_padding_Y)
  
  ##################################################  
  # prepare JS
  ##################################################
  
  # read in JS template
  js <- readLines("data/templates/JS-template.js")
  
  # add in data
  js <- stringr::str_replace(js, "GEOJSON_DATA", geojson)
  
  # set map dimensions
  js <- stringr::str_replace(js, "WIDTH", as.character(width))
  js <- stringr::str_replace(js, "HEIGHT", as.character(height))
  
  ##################################################  
  # prepare output files
  ##################################################
  
  # prepare a single file
  if(single_file) {
    
    # read in HTML
    html <- readLines("data/templates/HTML-template-single.html")
    
    # include JS
    js <- stringr::str_c(js, collapse = "\n")
    html <- stringr::str_replace(html, "JS_CODE", js)
    
    # include CSS
    css <- stringr::str_c(css, collapse = "\n")
    html <- stringr::str_replace(html, "CSS_CODE", css) 
    
    # write HTML file
    writeLines(html, stringr::str_c(file_prefix, ".html"))
  }
  
  # prepare multiple files
  else if(!single_file) {
    
    # edit HTML
    html <- readLines("data/templates/HTML-template-multiple.html")
    
    # include JS
    html <- stringr::str_replace(html, "FILE_PREFIX", file_prefix)
    
    # include CSS
    html <- stringr::str_replace(html, "FILE_PREFIX", file_prefix) 
    
    # write HTML file
    writeLines(html, stringr::str_c(file_prefix, ".html"))
    
    # write JS file
    writeLines(js, stringr::str_c(file_prefix, ".js"))
    
    # write CSS file
    writeLines(css, stringr::str_c(file_prefix, ".css"))
  }
}

##################################################  
# test function
##################################################


formatting <- list(
  
  map_border_color = c(0.15, 0.15, 0.15),
  map_border_size = 1,
  map_background_color = c(0.97, 0.97, 0.97),
  
  feature_line_color = c(0.15, 0.15, 0.15),
  feature_fill_color = c(0.90, 0.90, 0.90),
  feature_line_size = 0.5,
  
  feature_line_color_hover = c(0.15, 0.15, 0.15),
  feature_fill_color_hover = c(0.80, 0.80, 0.80),
  feature_line_size_hover = 0.5,
  
  feature_line_color_select = c(0.15, 0.15, 0.15),
  feature_fill_color_select = c(0.70, 0.70, 0.70),
  feature_line_size_select = 0.5,
  
  feature_line_color_select_hover = c(0.15, 0.15, 0.15),
  feature_fill_color_select_hover = c(0.75, 0.75, 0.75),
  feature_line_size_select_hover = 0.5,
  
  tooltip_background_color = c(0, 0, 0, 0.7),
  tooltip_border_size = 0,
  tooltip_border_color = c(0.15, 0.15, 0.15),
  tooltip_font_size = 10,
  tooltip_font_color = c(1, 1, 1),
  tooltip_border_radius = 8,
  tooltip_padding_X = 16,
  tooltip_padding_Y = 8
)

make_D3_map(formatting = formatting, width = 610, height = 700, single_file = TRUE)

###########################################################################
# end R script
###########################################################################

