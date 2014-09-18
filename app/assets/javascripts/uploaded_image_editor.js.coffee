class @UploadedImageEditor
  constructor: (fileInputEl, editorEl, rotationEl) ->
    @redirectEvent('click', '#select-file', fileInputEl)
    imageEditor = undefined
    $(fileInputEl).on 'change', =>
      if fileInputEl.files != undefined && fileInputEl.files.length
        imageFile = fileInputEl.files[0]

        fr = new FileReader;

        fr.onloadend = ->
          # get EXIF data
          exif = EXIF.readFromBinaryFile(new BinaryFile(@result))

          # iPad
          exifRotation = switch(exif.Orientation)
            when 6 then 90
            when 3 then 180
            when 8 then 270
            else 0

          url = if window.URL then window.URL else window.webkitURL
          src = url.createObjectURL(imageFile)
          imageEditor = new ImageEditor(editorEl, src, rotationEl, exifRotation)

        fr.readAsBinaryString(imageFile) # read the file
        $(editorEl).closest('.form-group').show()
      else
        imageEditor.reset() if imageEditor
        $(editorEl).closest('.form-group').hide()

  redirectEvent: (event, source, destination) ->
    $(source).on event, (e) ->
      e.preventDefault()
      $(destination).trigger event

