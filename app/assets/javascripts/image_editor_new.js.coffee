$ ->
  image = $('#image-rotation-box img')

  image.on 'load', ->
    image.guillotine { width: 90, height: 90, eventOnChange: 'imageDidChange' }
    image.guillotine 'fit'
    image.show()

    $('[data-action]').on 'click', (e) ->
      e.preventDefault()
      image.guillotine $(this).data('action')

    image.on 'imageDidChange', (e, data, action) -> console.log(data)

  
  $('input[type="hidden"].image_url').on 'imageUrlDidSet', ->
    src = $(this).val()
    console.log(src)
    
    image.prop('src', src)
  