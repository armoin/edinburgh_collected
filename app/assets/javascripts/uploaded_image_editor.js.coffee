class @UploadedImageEditor
  constructor: (fileInputEl, @imageEditorController) ->
    $('body').on 'change', '#memory_source', =>
      if fileInputEl.files != undefined && fileInputEl.files.length
        imageFile = fileInputEl.files[0]

        fr = new FileReader

        fr.onloadend = =>
          # get EXIF data
          exif = EXIF.readFromBinaryFile(new BinaryFile(fr.result))

          # convert to rotation
          exifRotation = switch(exif.Orientation)
            when 6 then 90
            when 3 then 180
            when 8 then 270
            else 0

          url = if window.URL then window.URL else window.webkitURL
          src = url.createObjectURL(imageFile)

          @imageEditorController.addSrc(src)

        fr.readAsBinaryString(imageFile) # read the file

      else
        @imageEditorController.addSrc('')

