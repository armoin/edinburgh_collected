class @ImageEditorController
  constructor: (@editorEl, @rotationEl) ->
    @createRotateEvent('left', -90)
    @createRotateEvent('right', 90)
    @reset()
    @showHideToggle()

  showHideToggle: =>
    src = $('img.upload').attr('src')
    if ( src == '' or src == undefined )
      $(@editorEl).closest('.form-group').hide()
    else
      $(@editorEl).closest('.form-group').show()

  addSrc: (src) =>
    @reset()
    $(@editorEl).find('img.upload').attr('src', src)
    @showHideToggle()

  createRotateEvent: (direction, amount) =>
    $("#rotate-#{direction}").on 'click', (e) =>
      e.preventDefault()
      current_rotation = $(@rotationEl).val()
      if (current_rotation == '' || isNaN(current_rotation))
        current_rotation = 0
      rotation = (parseInt(current_rotation, 10) + amount) % 360
      $(@rotationEl).val(rotation)
      $('#image-wrapper')
        .removeClass()
        .addClass('rotate' + rotation)

  reset: =>
    $(@editorEl).find('#image-wrapper').removeClass()
    # $(@editorEl).find('img.upload').attr('src', '')
    $(@rotationEl).val(0)

