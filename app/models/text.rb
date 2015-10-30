class Text < Memory
  THUMBNAIL_IMAGE = 'speach-bubble-large-4.png'

  def source_url(version=nil)
    return nil if version.nil?
    THUMBNAIL_IMAGE
  end
end
