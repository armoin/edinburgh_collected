class TempImagesController < ApplicationController
  def create
    temp_image = TempImage.create(temp_image_params)
    render json: temp_image
  end

  private

  def temp_image_params
    params.require(:temp_image).permit(:file)
  end
end
