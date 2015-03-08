class TempImagesController < ApplicationController
  def create
    # See https://github.com/blueimp/jQuery-File-Upload/wiki/Setup#content-type-negotiation
    # and https://github.com/blueimp/jQuery-File-Upload/wiki/Frequently-Asked-Questions#why-does-internet-explorer-prompt-to-download-a-file-after-the-upload-completes
    # for explanation of why content_type is required for IE9

    temp_image = TempImage.new(temp_image_params)
    if temp_image.save
      render json: temp_image, content_type: request.format
    else
      render json: {errors: temp_image.errors}, content_type: request.format, status: 422
    end
  end

  private

  def temp_image_params
    params.require(:temp_image).permit(:file)
  end
end
