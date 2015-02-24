class TempImage < ActiveRecord::Base
  mount_uploader :file, TempImageFileUploader
end
