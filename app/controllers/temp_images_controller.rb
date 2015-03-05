class TempImagesController < ApplicationController
  def create
    temp_image = TempImage.create(temp_image_params)

    # See https://github.com/blueimp/jQuery-File-Upload/wiki/Setup#content-type-negotiation
    # and https://github.com/blueimp/jQuery-File-Upload/wiki/Frequently-Asked-Questions#why-does-internet-explorer-prompt-to-download-a-file-after-the-upload-completes
    # for explanation of why content_type is required for IE9
    render json: temp_image, content_type: request.format
  end

  private

  def temp_image_params
    params.require(:temp_image).permit(:file)
  end
end
