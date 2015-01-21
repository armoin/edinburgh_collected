class @UploadedImageEditor
  constructor: (fileInputEl, @imageEditorController) ->
    $('body').on 'change', '#memory_source', =>
      if fileInputEl.files && fileInputEl.files.length
        imageFile = fileInputEl.files[0]

        fr = new FileReader

        fr.onloadend = =>
          url = if window.URL then window.URL else window.webkitURL
          src = url.createObjectURL(imageFile)

          @imageEditorController.addSrc(src)

        fr.readAsArrayBuffer(imageFile) # read the file

      else
        @imageEditorController.addSrc('')

