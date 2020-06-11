// ==================================================
// geojson data
// ==================================================

// enter data
var mapData = GEOJSON_DATA

// ==================================================
// general setup
// ==================================================

// dimensions
var width = WIDTH
var height = HEIGHT

// select svg element and apply dimensions
var svg = d3.select("svg")
  .attr("width", width)
  .attr("height", height)

// define variables
var selectedFeature = d3.select(null)
var shadedFeature = d3.select(null)
var featureUnderMouse = d3.select(null)
var featureUnderMouseOnZoom = d3.select(null)
var zoomingOn = false
var mousePosition = [,]

// make a color scale
var colorScale = d3.scaleThreshold()
  .domain([100000, 1000000, 10000000, 30000000, 100000000, 500000000])
  .range(d3.schemeBlues[7])

// ==================================================
// create the projection
// ==================================================

// create a projection
var projection = d3.geoMercator()
  .scale(1)
  .translate([0, 0])

// make a path generator
var path = d3.geoPath()
  .projection(projection)

// calculate bounds
var bounds = path.bounds(mapData)

// calculate new scale
var scale = 1.02 / Math.max((bounds[1][0] - bounds[0][0]) / width, (bounds[1][1] - bounds[0][1]) / height)

// calculate new translation
var translation = [(width - scale * (bounds[1][0] + bounds[0][0])) / 2, (height - scale * (bounds[1][1] + bounds[0][1])) / 2]

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
  .attr("fill", "white")

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
  .scaleExtent([1, 20])
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

  // record which country the mouse is over when zooming starts
  featureUnderMouseOnZoom = featureUnderMouse
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

  // update line width to keep it constant
  d.attr("stroke-width", 0.5 / thisEvent.k + "px")
}

// runs when zooming ends
function onZoomEnd() {

  // mark that zooming is ending to allow other mouse events
  zoomingOn = false

  console.log(mousePosition)

  // get the feature under the mouse
  // featureUnderMouse = d3.select(document.elementFromPoint(mousePosition[0], mousePosition[1]))

  // if the mouse end position is over water
  //featureUnderMouse.node() === document.getElementById("map")
  if(featureUnderMouse.node() === null) {

    // log message
    console.log("end zoom in water")

    // unshade currently shaded feature
    shadedFeature.classed("hovering", false)

    // clean currently shaded feature
    shadedFeature = d3.select(null)

    // turn off tooltip
    turnTooltipOff()

  // if the mouse end position is over land
  } else {

    // if mouse end position is over the same country as when zooming started
    if(featureUnderMouse.node() === featureUnderMouseOnZoom.node()) {

      // print message
      console.log("end zoom on same feature")

      // turn the tooltip back on
      turnTooltipOn()

    // if mouse end position is over a different country than when zooming started
    } else {

      // print message
      console.log("end zoom on different feature")

      // unshade the currently shaded country (if any)
      shadedFeature.classed("hovering", false)

      // shade the country that is currently under the mouse (if any)
      shadedFeature = featureUnderMouse.classed("hovering", true)

      // turn the tooltip back on
      turnTooltipOn()
    }
  }
}

// ==================================================
// feature selection functions
// ==================================================

// // function to select a feature
// function selectFeature(d) {
//
//   // unselect the currently selected feature (if there is one)
//   selectedFeature.classed("selected", false)
//
//   // calculate bounds of the country that was clicked on
//   var bounds = path.bounds(d),
//
//   // x range
//   dx = bounds[1][0] - bounds[0][0],
//
//   // y range
//   dy = bounds[1][1] - bounds[0][1],
//
//   // half
//   x = (bounds[0][0] + bounds[1][0]) / 2,
//
//   // half
//   y = (bounds[0][1] + bounds[1][1]) / 2,
//
//   // new scale
//   scale = Math.max(1, Math.min(20, 0.9 / Math.max(dx / width, dy / height))),
//
//   // new translate
//   translate = [width / 2 - scale * x, height / 2 - scale * y];
//
//   // zoom in on this feature
//   d3.event.stopPropagation()
//   svg.transition().duration(400).call(
//     zoom.transform,
//     d3.zoomIdentity
//     .translate(translate[0], translate[1])
//     .scale(scale)
//   )
// }

// function to deselect a feature
function deselectFeature() {

  // change the CSS class of the currently selected feature
  svg.transition().duration(400).call(zoom.transform, d3.zoomIdentity)

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
  // featureUnderMouse = d3.select(document.elementFromPoint(mousePosition[0], mousePosition[1]))
  featureUnderMouse = d3.select(this)

  // update the tooltip HTML
  tooltip.html(d.properties.ADMIN_name)

  // if not currently zooming
  if(zoomingOn === false) {

    // turn on the tooltip
    turnTooltipOn()

    // unshade the shaded feature (if any)
    shadedFeature.classed("hovering", false)

    // shade the currently shaded feature
    shadedFeature = d3.select(this).classed("hovering", true)
  }
}

// function to close the tooltip
function onMouseLeave() {

  // clear the country recorded as being under the mouse
  featureUnderMouse = d3.select(null)
  console.log("onMouseLeave")

  // if not currently zooming
  if(zoomingOn === false) {

    // turn off the tooltip
    turnTooltipOff()

    // unshade the currently shaded feature (if any)
    shadedFeature.classed("hovering", false)

    // unshade the currently shaded feature
    shadedFeature = d3.select(null)
  }
}

// function to update the position of the tooltip when the mouse moves
function onMouseMove() {

  var x = d3.mouse(this)[0] + document.getElementById("map").getBoundingClientRect().x
  var y = d3.mouse(this)[1] + document.getElementById("map").getBoundingClientRect().y
  mousePosition = [x, y]

  // update the tooltip position
  updateTooltipPosition()
}

// runs when the mouse is clicked
function onClick(d) {

  // if this is the currently selected feature
  if(selectedFeature.node() === this) {

    // deselect the feature
    deselectFeature()

  // if this is not the currently selected feature
  } else {

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
    var scale = Math.max(1, Math.min(20, 0.9 / Math.max(xRange / width, yRange / height)))

    // new translate
    var translate = [width / 2 - scale * x, height / 2 - scale * y]

    // zoom in on this feature
    d3.event.stopPropagation()
    svg.transition().duration(400).call(
      zoom.transform,
      d3.zoomIdentity
      .translate(translate[0], translate[1])
      .scale(scale)
    )
  }
}

// ==================================================
// end JS file
// ==================================================
