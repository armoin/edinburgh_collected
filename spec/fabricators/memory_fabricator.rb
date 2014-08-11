Fabricator(:memory) do
  user
  area
  year        "2014"
  month       "5"
  day         "4"
  file_type   "image"
  title       "A test"
  description "This is a test."
  attribution "Bobby Tables"
  location    "Kings Road"
  source      Rack::Test::UploadedFile.new(File.join(File.join(Rails.root, 'spec', 'fixtures', 'files'), 'test.jpg'))
end

