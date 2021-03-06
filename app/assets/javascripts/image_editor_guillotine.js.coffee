$ ->
  $image      = $('.guillotine #image-rotation-box img')
  $remote_url = $('input[type="hidden"].image_url')

  imageAttached = ->
    url = $remote_url.val()
    $image.prop('src', url) if url
    $('#image-editor').trigger('imageDidShow')

  $remote_url.on 'imageFileAdded', imageAttached
  $remote_url.on 'change', imageAttached

  logData = (data) ->
    $('[data-attr="angle"]').val(data.angle)
    $('[data-attr="scale"]').val(data.scale)
    $('[data-attr="w"]').val(data.w)
    $('[data-attr="h"]').val(data.h)
    $('[data-attr="x"]').val(data.x)
    $('[data-attr="y"]').val(data.y)

  $('[data-action]').on 'click', (e) ->
    e.preventDefault()
    $image.guillotine $(this).data('action')

  $image.on 'imageDidChange', (e, data, action) -> logData(data)

  $image.on 'load', ->
    $image.guillotine 'remove'
    $image.guillotine {
      width: $image.data('width'),
      height: $image.data('height'),
      eventOnChange: 'imageDidChange'
    }
    $image.guillotine 'fit'

    logData $image.guillotine('getData')

    $('#image-editor .progress').hide()
    $image.closest('#image-rotation-box').show()
    $("#image-editor").show()

  if $remote_url.val() && $remote_url.val().length
    $remote_url.trigger('imageFileAdded')
  else if $("#image-editor").data('show')
    $image.trigger('load')
