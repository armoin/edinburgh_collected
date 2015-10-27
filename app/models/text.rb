class Text < Memory
  THUMBNAIL_IMAGE = 'speech_bubble.png'

  def source_url(version=nil)
    return nil if version.nil?
    THUMBNAIL_IMAGE
  end
end
