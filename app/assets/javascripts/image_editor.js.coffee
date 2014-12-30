class @ImageEditorController
  constructor: (@editorEl, @rotationEl) ->
    @createRotateEvent('left', -90)
    @createRotateEvent('right', 90)
    @reset()
    @showHideToggle()

  showHideToggle: =>
    src = $(@editorEl).find('#image-rotation-box img').attr('src')
    if ( src == '' or src == undefined )
      $(@editorEl).hide()
    else
      $(@editorEl).show()

  addSrc: (src) =>
    $(@editorEl).find('#image-rotation-box img').attr('src', src)
    @reset()
    @showHideToggle()

  createRotateEvent: (direction, amount) =>
    $("#rotate-#{direction}").on 'click', (e) =>
      e.preventDefault()
      current_rotation = $(@rotationEl).val()
      if (current_rotation == '' || isNaN(current_rotation))
        current_rotation = 0
      rotation = (parseInt(current_rotation, 10) + amount) % 360
      $(@rotationEl).val(rotation)
      $('#image-rotation-box')
        .removeClass()
        .addClass('rotate' + rotation)

  reset: =>
    $(@editorEl).find('#image-rotation-box').removeClass()
    $(@rotationEl).val(0)

