class Link < ActiveRecord::Base
  belongs_to :user
  
  validates :name, presence: true
  validates :url, presence: true, url: {no_local: true}

  def url_without_protocol
    url.gsub /https?:\/\//, ''
  end
end