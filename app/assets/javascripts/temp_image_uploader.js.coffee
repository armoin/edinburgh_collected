fileAdded = (e, data) ->
  data.context = $("#image-editor")
  data.context.find('.errors').hide()
  data.context.find('#image-rotation-box').hide()
  progress = data.context.find('.progress')
  progress.find('.bar').css('width', 0)
  progress.show()
  data.submit()

fileUploading = (e, data) ->
  if data.context
    progress = parseInt(data.loaded / data.total * 100, 10)
    data.context.find('.bar').css('width', progress + '%')

fileDidUpload = (e, data) ->
  file = data.result.file
  if file
    imageUrl = file.url
    $('input[type="hidden"].image_url').val(imageUrl).trigger('imageFileAdded')
  else
    # Internet Explorer
    fileDidFail(e, data)

fileDidFail = (e, data) ->
  fileErrors = data.jqXHR.responseJSON.errors.file
  if fileErrors.length
    errors = data.context.find('.errors')
    errors.text(fileErrors.join(', ')).show()
    data.context.find('.progress').hide()

$ ->
  $('form#new_temp_image').fileupload
    dataType: 'json'
    add: fileAdded
    progress: fileUploading
    done: fileDidUpload
    fail: fileDidFail