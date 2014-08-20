Fabricator(:memory, from: :image) do
  user
  area
  year        "2014"
  month       "5"
  day         "4"
  title       "A test"
  description "This is a test."
  attribution "Bobby Tables"
  location    "Kings Road"
  source      Rack::Test::UploadedFile.new(File.join(File.join(Rails.root, 'spec', 'fixtures', 'files'), 'test.jpg'))
  categories(rand: 3) { |attrs, i| Fabricate(:category) }
end

Fabricator(:image_memory, from: :image) do
  user
  area
  year        "2014"
  month       "5"
  day         "4"
  title       "A test"
  description "This is a test."
  attribution "Bobby Tables"
  location    "Kings Road"
  source      Rack::Test::UploadedFile.new(File.join(File.join(Rails.root, 'spec', 'fixtures', 'files'), 'test.jpg'))
  categories(rand: 3) { |attrs, i| Fabricate(:category) }
end

