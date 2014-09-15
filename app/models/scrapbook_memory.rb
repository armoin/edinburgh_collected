class ScrapbookMemory < ActiveRecord::Base
  belongs_to :scrapbook
  belongs_to :memory
end
