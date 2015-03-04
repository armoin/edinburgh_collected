$ ->
  image = $('#image-rotation-box img')

  image.on 'load', ->
    image.guillotine { width: 90, height: 90, eventOnChange: 'imageDidChange' }
    image.guillotine 'fit'
    image.find('.progress').hide()
    image.show()

    $('[data-action]').on 'click', (e) ->
      e.preventDefault()
      image.guillotine $(this).data('action')

    image.on 'imageDidChange', (e, data, action) ->
      console.log(data)
      $('#user_image_angle').val(data.angle)
      $('#user_image_scale').val(data.scale)
      $('#user_image_w').val(data.w)
      $('#user_image_h').val(data.h)
      $('#user_image_x').val(data.x)
      $('#user_image_y').val(data.y)

  
  $('input[type="hidden"].image_url').on 'imageUrlDidSet', ->
    src = $(this).val()
    console.log(src)
    
    image.prop('src', src)
  