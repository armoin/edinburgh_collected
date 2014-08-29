class @ImageEditor
  constructor: (@editorEl, src, @rotationEl) ->
    @reset()
    img = new Image()
    img.src = src
    img.onload = (e) =>
      svg = @buildSVG(img)
      @createRotateEvent(svg, 'left', -90)
      @createRotateEvent(svg, 'right', 90)
    $(@editorEl).show()

  buildSVG: (img) ->
    imageMeasurements = ImageCalculator.calculateMeasurements(img)
    d = imageMeasurements.dimensions
    h = imageMeasurements.hypoteneus
    p = imageMeasurements.position
    paper = new Raphael($(@editorEl)[0], h, h)
    paper.image(img.src, p.x, p.y, d.width, d.height)

  createRotateEvent: (image, direction, amount) =>
    $("#rotate-#{direction}").on 'click', (e) =>
      e.preventDefault()
      if image
        @angle += amount
        image.stop().animate({transform: "r" + @angle}, 1000, "<>")
        $(@rotationEl).val(@angle % 360)

  reset: =>
    @angle = 0
    $(@editorEl).find('svg').remove()
    $(@rotationEl).val(0)

