require 'carrierwave/mount'

class Photo < Memory
  extend CarrierWave::Mount
  mount_uploader :source, ImageUploader

  include ImageManipulator

  validates :source, presence: true
  validates :year, presence: true

  def label
    'picture'
  end

  def info_list
    [
      'We currently support files of type .gif, .jpg, .jpeg or .png',
      'We do not store image files at their original size. Please make sure that you store your own copy.',
      'Please be aware the uploading files from a mobile device may incur charges from your mobile service provider.'
    ]
  end

  def update(params)
    super(params) && process_image
  end
end
