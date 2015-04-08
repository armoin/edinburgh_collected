class @Justified

  constructor: (@wrapper, @minHeight, @maxHeight) ->
    @images = $(@wrapper).find('img')

  setHeight: ->
    rowHeight = @calculateRowHeight()

    $.each @images, (i, image) ->
      $(image).height(rowHeight)

    $(@wrapper).trigger('didFinishSettingHeights')

  calculateRowHeight: ->
    widths = []
    containerWidth = $(@wrapper).innerWidth()

    $.each @images, (i, image) =>
      heightRatio = @maxHeight / image.height
      widths.push image.width * heightRatio

    totalWidth = widths.reduce (a,b) -> a+b

    paddingWidth = widths.length * 12
    marginWidth  = (widths.length-1) * 5

    containerWidthRaw = containerWidth - paddingWidth - marginWidth

    widthRatio = containerWidthRaw / totalWidth
    rowHeight = Math.floor(@maxHeight * widthRatio)

    rowHeight