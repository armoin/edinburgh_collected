Fabricator(:asset) do
  user
  year      "2014"
  file_type "image"
  title     "A test"
  source    Rack::Test::UploadedFile.new(File.join(File.join(Rails.root, 'spec', 'fixtures', 'files'), 'test.jpg'))
  area_id   1
end

