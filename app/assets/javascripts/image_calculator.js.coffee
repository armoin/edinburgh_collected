class @ImageCalculator
  MAX_DIMENSION = 200

  constructor: (@image) ->

  @calculateMeasurements: (image)->
    dimensions = getDimensions(image)
    hypoteneus = getHypoteneus(dimensions)
    position   = getPosition(dimensions, hypoteneus)
    {
      dimensions: dimensions,
      hypoteneus: hypoteneus,
      position:   position
    }

  getDimensions = (image) ->
    return {width: image.width, height: image.height} unless needsToBeScaled(image)
    width = MAX_DIMENSION
    height = MAX_DIMENSION
    if image.width > image.height
      height = (MAX_DIMENSION/image.width) * image.height
    else
      width = (MAX_DIMENSION/image.height) * image.width
    {width: width, height: height}

  needsToBeScaled = (image) ->
    image.width >= MAX_DIMENSION || image.height >= MAX_DIMENSION

  getHypoteneus = (dimensions) ->
    square_width = dimensions.width * dimensions.width
    square_height = dimensions.height * dimensions.height
    Math.sqrt(square_width + square_height)

  getPosition = (dimensions, hypoteneus) ->
    {
      x: (hypoteneus - dimensions.width) / 2,
      y: (hypoteneus - dimensions.height) / 2
    }

