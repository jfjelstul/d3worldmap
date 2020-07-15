// ==================================================
// geojson data
// ==================================================

// enter data
var mapData = {{GEOJSON_DATA}}

// ==================================================
// general setup
// ==================================================

// dimensions
var width = {{WIDTH}}
var height = {{HEIGHT}}

// select svg element and apply dimensions
var svg = d3.select("svg")
  .attr("width", width)
  .attr("height", height)

// stroke width
var strokeWidth = {{FEATURE_LINE_SIZE}}
var strokeWidthHover = {{FEATURE_LINE_SIZE_HOVER}}

// zoom parameters
var zoomingOn = false
var max_zoom = {{MAX_ZOOM}}
var zoom_speed = {{ZOOM_SPEED}}
var currentK = 1

// define variables
var selectedFeature = d3.select(null)
var shadedFeature = d3.select(null)

// mouse parameters
var featureUnderMouse = d3.select(null)
var mousePosition = [,]

// color parameters
var choropleth = {{CHOROPLETH}}

// ==================================================
// create the projection
// ==================================================

// create a projection
var projection = d3.geoIdentity()
 .reflectY(true)

// make a path generator
var path = d3.geoPath()
  .projection(projection)

// calculate bounds
var bounds = path.bounds(mapData)

// calculate new scale
var scale = {{INITIAL_SCALE}}

// calculate new translation
var translation = [{{INITIAL_TRANSLATION_X}}, {{INITIAL_TRANSLATION_Y}}]

// update the projection with the new scale and translation
projection
  .scale(scale)
  .translate(translation)

// ==================================================
// draw the map
// ==================================================

// line width
var g = svg.append("g")
  .attr("stroke-width", 0.5 + "px")

// append paths
var d = g.selectAll("path")
  .data(mapData.features)
  .enter()
  .append("path")
  .attr("d", path)

// add colors
if(choropleth) {
  d.style("fill", function (d) {
    return d.properties.fill_color
  })
}

// initial stroke width
d.attr("stroke-width", strokeWidth / currentK + "px")

// ==================================================
// mouse events related to features
// ==================================================

// mouse events
d.on('mouseenter', onMouseEnter)
  .on("mouseleave", onMouseLeave)
  .on("click", onClick)

// ==================================================
// mouse events related to the svg element
// ==================================================

// mouse events
svg.on("click", deselectFeature)
  .on("mousemove", onMouseMove)

// ==================================================
// zoom functions
// ==================================================

// function to handle zooming
var zoom = d3.zoom()
  .translateExtent([[0, 0], [width, height]])
  .scaleExtent([1, max_zoom])
  .on("start", onZoomStart)
  .on("zoom", onZoom)
  .on("end", onZoomEnd)

// call the zoom function
svg.call(zoom)

// runs when zooming starts
function onZoomStart() {

  // mark that zooming is starting to disallow other mouse events
  zoomingOn = true

  // turn tooltip off
  turnTooltipOff()

  // unshade currently shaded feature
  shadedFeature.classed("hovering", false)

  // set the stroke width for the feature
  shadedFeature.attr("stroke-width", strokeWidth / currentK + "px")

  // clear currently shaded feature
  shadedFeature = d3.select(null)
}

// runs while zooming
function onZoom() {

  var x = d3.mouse(this)[0] + document.getElementById("map").getBoundingClientRect().x
  var y = d3.mouse(this)[1] + document.getElementById("map").getBoundingClientRect().y
  mousePosition = [x, y]

  // move tooltip
  updateTooltipPosition()

  // get event
  var thisEvent = d3.event.transform

  // bounded x change
  var xChange = Math.min(0, Math.max(thisEvent.x, width - width * thisEvent.k))

  // bounded y change
  var yChange = Math.min(0, Math.max(thisEvent.y, height - height * thisEvent.k))

  // update transform
  g.attr("transform", "translate(" + [xChange, yChange] + ") scale(" + thisEvent.k + ")")

  // save the zoom scale
  currentK = thisEvent.k;

  // update line width to keep it constant
  d.attr("stroke-width", strokeWidth / currentK + "px")
}

// runs when zooming ends
function onZoomEnd() {

  // mark that zooming is ending to allow other mouse events
  zoomingOn = false
}

// function to deselect a feature
function deselectFeature() {

  // change the CSS class of the currently selected feature
  svg.transition().duration(zoom_speed).call(zoom.transform, d3.zoomIdentity)

  selectedFeature.classed("selected", false)

  // unselect the currently selected feature
  selectedFeature = d3.select(null)
}

// ==================================================
// tooltip functions
// ==================================================

// make the tooltip
var tooltip = d3.select("body")
  .append("div")
  .attr("class", "tooltip")
  .style("opacity", 0)

// function to turn on the tooltip
function turnTooltipOn() {

  // apply transition
  tooltip.transition()
  .duration(250)
  .style("opacity", 1)
}

// function to turn off the tooltip
function turnTooltipOff() {

  // apply transition
  tooltip.transition()
  .duration(250)
  .style("opacity", 0)
}

// function to update tooltip position
function updateTooltipPosition() {

  // update tooltip CSS
  tooltip.style("left", (mousePosition[0] + 25) + "px").style("top", (mousePosition[1] + 25) + "px")
}

// ==================================================
// mouse event functions
// ==================================================

// function to show the tooltip
function onMouseEnter(d) {

  // raise the selected country to the front (to handle borders)
  d3.select(this).raise()

  // record the country being selected
  featureUnderMouse = d3.select(this)

  // update the tooltip HTML
  tooltip.html(d.properties.tooltip)

  // if not currently zooming
  if(zoomingOn === false) {

    // turn on the tooltip
    turnTooltipOn()

    // unshade the currently shaded feature (if any)
    shadedFeature.classed("hovering", false)

    // shade the new feature
    shadedFeature = d3.select(this).classed("hovering", true)

    // set the stroke width for the new feature
    shadedFeature.attr("stroke-width", strokeWidthHover / currentK + "px")
  }
}

// function to close the tooltip
function onMouseLeave() {

  // clear the country recorded as being under the mouse
  featureUnderMouse = d3.select(null)

  // turn off the tooltip
  turnTooltipOff()

  // unshade the feature
  shadedFeature.classed("hovering", false)

  // set the stroke width for the feature
  shadedFeature.attr("stroke-width", strokeWidth / currentK + "px")
}

// function to update the position of the tooltip when the mouse moves
function onMouseMove(d) {

  // move tooltip
  var x = d3.mouse(this)[0] + document.getElementById("map").getBoundingClientRect().x
  var y = d3.mouse(this)[1] + document.getElementById("map").getBoundingClientRect().y
  mousePosition = [x, y]

  // if not currently zooming
  if(zoomingOn === false) {

    if(shadedFeature !== featureUnderMouse || shadedFeature === d3.select(null)) {

      // unshade the feature
      shadedFeature.classed("hovering", false)

      // set the stroke width for the feature
      shadedFeature.attr("stroke-width", strokeWidth / currentK + "px")

      // if there is a feature under the mouse
      if(featureUnderMouse.node() !== null) {

        // shade the feature under the mouse
        shadedFeature = featureUnderMouse.classed("hovering", true)

        // update stroke width
        shadedFeature.attr("stroke-width", strokeWidthHover / currentK + "px")

        // turn tooltip on
        turnTooltipOn()
      }
    }
  }

  // update the tooltip position
  updateTooltipPosition()
}

// runs when the mouse is clicked
function onClick(d) {

  // unselect the currently selected feature (if there is one)
  selectedFeature.classed("selected", false)

  // select this feature
  selectedFeature = d3.select(this).classed("selected", true)

  // calculate bounds of the country that was clicked on
  var bounds = path.bounds(d)

  // x range
  var xRange = bounds[1][0] - bounds[0][0]

  // y range
  var yRange = bounds[1][1] - bounds[0][1]

  // divide range by 2
  var x = (bounds[0][0] + bounds[1][0]) / 2

  // divide range by 2
  var y = (bounds[0][1] + bounds[1][1]) / 2

  // new scale
  var scale = Math.max(1, Math.min(max_zoom, 0.9 / Math.max(xRange / width, yRange / height)))

  // new translate
  var translate = [width / 2 - scale * x, height / 2 - scale * y]

  // zoom in on this feature
  d3.event.stopPropagation()
  svg.transition().duration(zoom_speed).call(
    zoom.transform,
    d3.zoomIdentity
    .translate(translate[0], translate[1])
    .scale(scale)
  )
}

// ==================================================
// end JS file
// ==================================================
