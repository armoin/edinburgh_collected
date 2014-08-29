class @UploadedImageEditor
  constructor: (fileInputEl, editorEl, rotationEl) ->
    @redirectEvent('click', '#select-file', fileInputEl)
    imageEditor = undefined
    $(fileInputEl).on 'change', =>
      if fileInputEl.files.length
        imageFile = fileInputEl.files[0]
        url = if window.URL then window.URL else window.webkitURL
        src = url.createObjectURL(imageFile)
        imageEditor = new ImageEditor(editorEl, src, rotationEl)
      else
        imageEditor.reset() if imageEditor
        $(editorEl).hide()

  redirectEvent: (event, source, destination) ->
    $(source).on event, (e) ->
      e.preventDefault()
      $(destination).trigger event

