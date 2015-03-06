$ ->
  $image      = $('.new #image-rotation-box img')
  $remote_url = $('input[type="hidden"].image_url')

  addImageToEditor = -> $image.prop 'src', $remote_url.val()

  $remote_url.on 'imageUrlDidSet', addImageToEditor

  $remote_url.trigger('imageUrlDidSet')

  logData = (data) ->
    $('#user_image_angle').val(data.angle)
    $('#user_image_scale').val(data.scale)
    $('#user_image_w').val(data.w)
    $('#user_image_h').val(data.h)
    $('#user_image_x').val(data.x)
    $('#user_image_y').val(data.y)

  $image.on 'load', ->
    $image.guillotine 'remove'
    $image.guillotine { width: 90, height: 90, eventOnChange: 'imageDidChange' }
    $image.guillotine 'fit'
    $('#image-editor .progress').hide()
    logData $image.guillotine('getData')
    $image.show()

    $('[data-action]').on 'click', (e) ->
      e.preventDefault()
      $image.guillotine $(this).data('action')

    $image.on 'imageDidChange', (e, data, action) -> logData(data)
