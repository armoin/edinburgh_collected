class Link < ActiveRecord::Base
  DEFAULT_SCHEME    = 'http'
  PERMITTED_SCHEMES = %w(http https)

  belongs_to :user
  
  validates :name, presence: true
  validates :url, presence: true, url: {no_local: true}

  def url_without_protocol
    url.gsub /https?:\/\//, ''
  end

  def url=(url)
    uri = Addressable::URI.parse(url)
    unless scheme_permitted?(uri)
      uri.scheme = nil # remove any unpermitted schemes
      url = url_from_uri(uri)
    end
    write_attribute(:url, url)
  end

  private

  def scheme_permitted?(uri)
    uri.scheme.present? && PERMITTED_SCHEMES.include?(uri.scheme)
  end

  def url_from_uri(uri)
    full_url = prepend_scheme(uri.to_s)
    remove_extra_slashes(full_url)
  end

  def prepend_scheme(url)
    url.prepend("#{DEFAULT_SCHEME}://")
  end

  def remove_extra_slashes(url)
    url.gsub(/\/\/\/+/, '//')
  end
end