require 'carrierwave/mount'

class Photo < Memory
  extend CarrierWave::Mount
  mount_uploader :source, ImageUploader

  validates :source, presence: true
  validates :year, presence: true

  attr_accessor :rotation

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

  def rotation=(degrees_string)
    @rotation = degrees_string.to_i
  end

  def rotated?
    self.rotation.present? && self.rotation != 0
  end

  def update(params)
    update_successful = super(params)
    if rotated? && update_successful
      update_successful = update_successful && rotate_image
    end
    update_successful
  end

  private

  def rotate_image
    self.updated_at = Time.now
    self.source.recreate_versions!
    self.save
  end
end
