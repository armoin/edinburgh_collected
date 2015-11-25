class Text < Memory
  THUMBNAIL_IMAGE = 'speach-bubble-large-4.png'

  def label
    'text'
  end

  def info_list
    []
  end

  def source_url(version=nil)
    return nil if version.nil?
    THUMBNAIL_IMAGE
  end
end
