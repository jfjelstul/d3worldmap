###########################################################################
# Josh Fjelstul, Ph.D.
# 3dworldmap R package
###########################################################################

# set working directory
# setwd("~/Documents/d3worldmap/")

# source("R/calculate_dimensions.R")
# source("R/convert_color.R")
# source("R/create_bounding_box.R")
# source("R/expand_bounding_box.R")
# source("R/get_bounding_box_ranges.R")
# source("R/inject.R")
# source("R/run_quietly.R")

###########################################################################
# create formatting object
###########################################################################

# attributes <- list(
#   
#   map_border_color = c(0.15, 0.15, 0.15),
#   map_border_size = 1,
#   map_background_color = c(0.97, 0.97, 0.97),
#   
#   feature_line_color = c(0.15, 0.15, 0.15),
#   feature_fill_color = c(0.90, 0.90, 0.90),
#   feature_line_size = 0.5,
#   
#   feature_line_color_hover = c(0.15, 0.15, 0.15),
#   feature_fill_color_hover = c(0.80, 0.80, 0.80),
#   feature_line_size_hover = 0.5,
#   
#   feature_line_color_select = c(0.15, 0.15, 0.15),
#   feature_fill_color_select = c(0.70, 0.70, 0.70),
#   feature_line_size_select = 0.5,
#   
#   feature_line_color_select_hover = c(0.15, 0.15, 0.15),
#   feature_fill_color_select_hover = c(0.75, 0.75, 0.75),
#   feature_line_size_select_hover = 0.5,
#   
#   tooltip_background_color = c(0, 0, 0, 0.7),
#   tooltip_border_size = 0,
#   tooltip_border_color = c(0.15, 0.15, 0.15),
#   tooltip_font_size = 10,
#   tooltip_font_color = c(1, 1, 1),
#   tooltip_border_radius = 8,
#   tooltip_padding_X = 16,
#   tooltip_padding_Y = 8
# )

###########################################################################
# map function
###########################################################################

#' Make a D3 map
#'
#' This function creates an interactive D3 choropleth map of the world or of a selected group of countries. 
#' Safari and Chrome are fully supported. Support for other browers is not guaranteed.
#' This function uses open source boundary data from Natural Earth (\url{https://www.naturalearthdata.com/downloads/}). 
#'
#' @param attributes \code{list}. An list object created by the \code{attributes()} function.
#' The list can also be created by hand, but must include all of the named elements
#' included in the list returned by the \code{attributes()} function.
#' @param width \code{numeric}. The width of the map in the brower in \code{px}. 
#' If \code{width} is specified and \code{height} is \code{NULL}, the height will be calculated
#' automatically to display the selected countries. 
#' If both \code{width} and \code{height} are specified, the visible area will be exanded horizontally or vertically 
#' as necessary to achieve the requested aspect ratio. The selected countries will be centered.
#' @param height \code{numeric}. The height of the map in the brower in \code{px}. 
#' @param surrounding \code{logical}. If \code{TRUE}, displays all countries inside the bounding box.
#' @param main \code{logical}. If \code{TRUE}, displays only main geographic units of a country (excludes outlying islands and territories).
#' For example, for the United Kingdom, if \code{main} is \code{TRUE}, only Britain, Northern Ireland,
#' and other nearby islands like the Isle of Man will be displayed. 
#' If \code{main} is \code{false}, all of the territories and dependencies of the United Kingdom around the world will be displayed.
#' @param file_name \code{string}. The file name used for any files returned by the function.
#' Each file name will be followed by the appropriate file extension (.html, .css, or .js).
#' @param resolution \code{string}. Either \code{"low"} or \code{"high"}. 
#' If \code{"low"}, uses the medium scale data (1:50m) from Natural Earth.
#' If \code{"high"}, uses the large scale data (1:10m) from Natural Earth.
#' @param single_file \code{logical}. If \code{TRUE}, the function will return a single HTML file.
#' This file will include all HTML, CSS, JavaScript, and GEOJSON data required to display the map in a browser.
#' If \code{FALSE}, the function will return an HTML, a CSS file, and a JavaScript file. 
#' The Javascript file will include the GEOJSON data required to make the map.
#' The HTML file will automatically include references to the CSS and JavaScript files.
#' Place all of the files in the same folder and open the HTML file in a browser.
#' @param margin \code{numeric}. The size of the buffer between the edge of the map and the furthest extent
#' of the selected geometry in px. The margin applies to all four directions. 
#' @return If \code{singe_file} is \code{TRUE}, creates an HTML file in the current working directory.
#' This file includes a HTML, CSS, JavaScript, and GEOJSON data to produce the map. 
#' If \code{FALSE}, creates an HTML file, a CSS file, and a JavaScript file in the current working directory.
#' The JavaScript file will include all GEOJSON data required to display the map in a browser.
#' No objects are created in the R global environment. 
#' @examples
#' make_D3_map(
#' width = 700, 
#' height = 700, 
#' countries = c("NOR", "ITA"), 
#' attributes = attributes, 
#' surrounding = TRUE, 
#' main = TRUE, 
#' resolution = "high", 
#' margin = 25, 
#' single_file = TRUE
#' )

make_D3_map <- function(countries, data = NULL, max_zoom = 20, zoom_speed = 800, color_anchors, color_breaks, missing_color, file_prefix = "D3_map", surrounding = TRUE, main = TRUE, margin = 0, resolution = "low", single_file = TRUE, attributes = NULL, width = NULL, height = NULL) {
  
  ##################################################  
  # error handling
  ##################################################
  
  # check for attributes
  if(is.null(attributes)) {
    stop("please supply a attributes object")
  }
  
  ##################################################  
  # map resolution
  ##################################################
  
  # if resolution == "low", read in low resolution data
  if(resolution == "low") {
    map_data <- sf::read_sf("data/low-resolution-map")
  # if resolution == "high", read in high resolution data
  } else if(resolution == "high") {
    map_data <- sf::read_sf("data/high-resolution-map")
  }
  
  ##################################################  
  # create color data
  ##################################################
  
  # if there is data to merge in
  if(!is.null(data)) {
    
    # rename variables
    names(data) <- c("ST_code", "fill_variable", "tooltip")
    
    # merge in data
    map_data <- dplyr::left_join(map_data, data, by = "ST_code")
    
    # convert fill variable to a factor
    map_data$fill_variable <- cut(map_data$fill_variable, breaks = color_breaks)
    
    # create a color palette function
    palette <- colorRampPalette(colors = color_anchors)
    
    # create color data
    color_data <- dplyr::tibble(fill_variable = factor(levels(map_data$fill_variable)), fill_color = palette(color_breaks))
    
    # merge in color data
    map_data <- dplyr::left_join(map_data, color_data, by = c("fill_variable"))
    
    # fill in missing colors
    map_data$fill_color[is.na(map_data$fill_color)] <- missing_color
  }

  ##################################################  
  # prepare map data
  ##################################################
  
  # select data
  out <- map_data
  
  # apply projection
  out <- sf::st_transform(out, crs = "+proj=merc")
  
  # if surrounding == FALSE, select only the listed states
  if(!surrounding) {
    out <- dplyr::filter(out, ST_code %in% countries) 
  }
  
  # select bounding box data
  bounding_box_data <- dplyr::filter(out, ST_code %in% countries)

  # if main == TRUE, select only main geometry
  if(main) {
    bounding_box_data <- dplyr::filter(bounding_box_data, !stringr::str_detect(UNIT_code, "other"))
  }
  
  # make bounding box
  bounding_box <- create_bounding_box(bounding_box_data)

  # expand bounding box
  bounding_box <- expand_bounding_box(margin = margin, height = height, width = width, bounding_box = bounding_box)
  
  # adjust bounding box
  dimensions <- calculate_dimensions(height = height, width = width, bounding_box = bounding_box)
  
  # new bounding box
  bounding_box <- dimensions$bounding_box
  
  # new map dimensions (in px)
  height <- dimensions$height
  width <- dimensions$width
  
  # initial scale
  initial_scale <- 1 / max((bounding_box$xmax - bounding_box$xmin) / width, (-bounding_box$ymin - -bounding_box$ymax) / height)

  # initial translation
  initial_translation_x <- (width - initial_scale * (bounding_box$xmax + bounding_box$xmin)) / 2
  initial_translation_y <- (height - initial_scale * (-bounding_box$ymax + -bounding_box$ymin)) / 2
  
  # clip geometry based on the bounding box
  out <- run_quietly(sf::st_crop(sf::st_buffer(out, 0), xmin = bounding_box$xmin, ymin = bounding_box$ymin, xmax = bounding_box$xmax, ymax = bounding_box$ymax))

  ##################################################  
  # create tooltip
  ##################################################
  
  # tooltip HTML
  # out$tooltip <- out$ST_name
  
  ##################################################  
  # prepare GEOJSON data
  ##################################################
  
  # write file
  run_quietly(geojsonio::geojson_write(out, file = "data/temp.geojson"))
  
  # prepare data
  geojson <- run_quietly(readLines("data/temp.geojson"))
  
  ##################################################  
  # prepare CSS
  ##################################################
  
  # read in CSS template
  css <- readLines("data/templates/CSS-template.css")
  
  # map border
  css <- inject(css, "MAP_BORDER_COLOR", attributes$map_border_color, color = TRUE)
  css <- inject(css, "MAP_BORDER_SIZE", attributes$map_border_size)
  css <- inject(css, "MAP_BACKGROUND_COLOR", attributes$map_background_color, color = TRUE)
  
  # features (default)
  css <- inject(css, "FEATURE_LINE_COLOR", attributes$feature_line_color, color = TRUE)
  css <- inject(css, "FEATURE_FILL_COLOR", attributes$feature_fill_color, color = TRUE)
  css <- inject(css, "FEATURE_LINE_SIZE", attributes$feature_line_size)
  
  # features (hover)
  css <- inject(css, "FEATURE_LINE_COLOR_HOVER", attributes$feature_line_color_hover, color = TRUE)
  css <- inject(css, "FEATURE_FILL_COLOR_HOVER", attributes$feature_fill_color_hover, color = TRUE)
  css <- inject(css, "FEATURE_LINE_SIZE_HOVER", attributes$feature_line_size_hover)
  
  # features (select)
  css <- inject(css, "FEATURE_LINE_COLOR_SELECT", attributes$feature_line_color_select, color = TRUE)
  css <- inject(css, "FEATURE_FILL_COLOR_SELECT", attributes$feature_fill_color_select, color = TRUE)
  css <- inject(css, "FEATURE_LINE_SIZE_SELECT", attributes$feature_line_size_select)
  
  # features (select and hover)
  css <- inject(css, "FEATURE_LINE_COLOR_SELECT_HOVER", attributes$feature_line_color_select_hover, color = TRUE)
  css <- inject(css, "FEATURE_FILL_COLOR_SELECT_HOVER", attributes$feature_fill_color_select_hover, color = TRUE)
  css <- inject(css, "FEATURE_LINE_SIZE_SELECT_HOVER", attributes$feature_line_size_select_hover)
  
  # tooltip
  css <- inject(css, "TOOLTIP_BACKGROUND_COLOR", attributes$tooltip_background_color, color = TRUE)
  css <- inject(css, "TOOLTIP_BORDER_SIZE", attributes$tooltip_border_size)
  css <- inject(css, "TOOLTIP_BORDER_COLOR", attributes$tooltip_border_color, color = TRUE)
  css <- inject(css, "TOOLTIP_FONT_SIZE", attributes$tooltip_font_size)
  css <- inject(css, "TOOLTIP_FONT_COLOR", attributes$tooltip_font_color, color = TRUE)
  css <- inject(css, "TOOLTIP_BORDER_RADIUS", attributes$tooltip_border_radius)
  css <- inject(css, "TOOLTIP_PADDING_X", attributes$tooltip_padding_X)
  css <- inject(css, "TOOLTIP_PADDING_Y", attributes$tooltip_padding_Y)
  
  ##################################################  
  # prepare JS
  ##################################################
  
  # read in JS template
  js <- readLines("data/templates/JS-template.js")
  
  # add in data
  js <- inject(js, "GEOJSON_DATA", geojson)
  
  # set map dimensions
  js <- inject(js, "WIDTH", width)
  js <- inject(js, "HEIGHT", height)
  
  # line width
  js <- inject(js, "FEATURE_LINE_SIZE", attributes$feature_line_size)
  js <- inject(js, "FEATURE_LINE_SIZE_HOVER", attributes$feature_line_size_hover)
  
  # choropleth
  js <- inject(js, "CHOROPLETH", ifelse(is.null(data), "false", "true"))
  
  # max zoom
  js <- inject(js, "MAX_ZOOM", max_zoom)
  
  # zoom speed
  js <- inject(js, "ZOOM_SPEED", zoom_speed)
  
  # set initial position
  js <- inject(js, "INITIAL_SCALE", initial_scale)
  js <- inject(js, "INITIAL_TRANSLATION_X", initial_translation_x)
  js <- inject(js, "INITIAL_TRANSLATION_Y", initial_translation_y)
  
  ##################################################  
  # prepare output files
  ##################################################
  
  # prepare a single file
  if(single_file) {
    
    # read in HTML
    html <- readLines("data/templates/HTML-template-single.html")
    
    # include JS
    js <- stringr::str_c(js, collapse = "\n")
    html <- inject(html, "JS_CODE", js)
    
    # include CSS
    css <- stringr::str_c(css, collapse = "\n")
    html <- inject(html, "CSS_CODE", css) 
    
    # write HTML file
    writeLines(html, stringr::str_c(file_prefix, ".html"))
  }
  
  # prepare multiple files
  else if(!single_file) {
    
    # edit HTML
    html <- readLines("data/templates/HTML-template-multiple.html")
    
    # include JS
    html <- inject(html, "FILE_PREFIX", file_prefix)
    
    # include CSS
    html <- inject(html, "FILE_PREFIX", file_prefix) 
    
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

attributes <- list(

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

# tall example
make_D3_map(width = NULL, height = 500, countries = c("DEU", "NOR"), attributes = attributes, surrounding = FALSE, main = TRUE, resolution = "low", margin = 25, single_file = TRUE)
make_D3_map(width = 500, height = NULL, countries = c("DEU", "NOR"), attributes = attributes, surrounding = FALSE, main = TRUE, resolution = "low", margin = 25, single_file = TRUE)
make_D3_map(width = 500, height = 500, countries = c("DEU", "NOR"), attributes = attributes, surrounding = FALSE, main = TRUE, resolution = "low", margin = 25, single_file = TRUE)

# wide example
make_D3_map(width = NULL, height = 400, countries = c("PRT", "ITA"), attributes = attributes, surrounding = FALSE, main = TRUE, resolution = "low", margin = 25, single_file = TRUE)
make_D3_map(width = 500, height = NULL, countries = c("PRT", "ITA"), attributes = attributes, surrounding = FALSE, main = TRUE, resolution = "low", margin = 25, single_file = TRUE)
make_D3_map(width = 500, height = 500, countries = c("PRT", "ITA"), attributes = attributes, surrounding = FALSE, main = TRUE, resolution = "low", margin = 25, single_file = TRUE)

make_D3_map(width = 500, height = 500, countries = c("PRT", "ITA"), attributes = attributes, surrounding = FALSE, main = TRUE, resolution = "low", margin = 100, single_file = TRUE)
make_D3_map(width = 500, height = 500, countries = c("PRT", "ITA"), attributes = attributes, surrounding = TRUE, main = TRUE, resolution = "low", margin = 100, single_file = TRUE)

make_D3_map(width = 500, height = 500, countries = c("DEU", "NOR"), attributes = attributes, surrounding = TRUE, main = TRUE, resolution = "low", margin = 50, single_file = TRUE)
make_D3_map(width = 500, height = 500, countries = c("DEU", "NOR"), attributes = attributes, surrounding = TRUE, main = FALSE, resolution = "low", margin = 50, single_file = TRUE)

# map settings
attributes <- list(
  
  map_border_color = c(0.15, 0.15, 0.15),
  map_border_size = 1,
  map_background_color = c(0.97, 0.97, 0.97),
  
  feature_line_color = c(0.15, 0.15, 0.15),
  feature_fill_color = c(0.90, 0.90, 0.90),
  feature_line_size = 1,
  
  feature_line_color_hover = c(0.15, 0.15, 0.15),
  feature_fill_color_hover = c(0.80, 0.80, 0.80),
  feature_line_size_hover = 2,
  
  feature_line_color_select = c(0.15, 0.15, 0.15),
  feature_fill_color_select = c(0.70, 0.70, 0.70),
  feature_line_size_select = 1,
  
  feature_line_color_select_hover = c(0.15, 0.15, 0.15),
  feature_fill_color_select_hover = c(0.75, 0.75, 0.75),
  feature_line_size_select_hover = 2,
  
  tooltip_background_color = c(0, 0, 0, 0.7),
  tooltip_border_size = 0,
  tooltip_border_color = c(0.15, 0.15, 0.15),
  tooltip_font_size = 10,
  tooltip_font_color = c(1, 1, 1),
  tooltip_border_radius = 8,
  tooltip_padding_X = 16,
  tooltip_padding_Y = 8
)

# make test data
data <- dplyr::tibble(ST_code = unique(map_data$ST_code), ST_name = unique(map_data$ST_name))
data$var <- runif(nrow(data), 0, 1)
data$var[data$ST_code == "DEU"] <- NA

# tooltip
data$tooltip <- stringr::str_c(data$ST_name, ": ", ifelse(is.na(data$var), "Missing", round(data$var, 2)))
data$ST_name <- NULL

# make map
make_D3_map(
  data = data, attributes = attributes, 
  countries = c("ITA", "NOR"), 
  width = 700, height = 700, margin = 50,
  zoom_speed = 800, max_zoom = 8, 
  color_anchors = c("#3498DB", "#FFFFFF", "#E74C3C"), color_breaks = 10, 
  missing_color = "gray85",
  surrounding = TRUE, main = TRUE, 
  resolution = "low", single_file = TRUE
)

###########################################################################
# end R script
###########################################################################
