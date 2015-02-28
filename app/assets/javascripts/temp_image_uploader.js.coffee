fileAdded = (e, data) ->
  data.context = $(".progress")
  data.context.show()
  data.submit()

fileUploading = (e, data) ->
  if data.context
    progress = parseInt(data.loaded / data.total * 100, 10)
    data.context.find('.bar').css('width', progress + '%')

fileDidUpload = (e, data) ->
  imageUrl = data.result.file.url
  $('input[type="hidden"].image_url').val(imageUrl)
  data.context.hide()

$ ->
  $('form#new_temp_image').fileupload
    dataType: 'json'
    add: fileAdded
    progress: fileUploading
    done: fileDidUpload