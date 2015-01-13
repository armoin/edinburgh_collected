Fabricator(:area) do
  name      'Portobello'
  city      ENV['CITY']
  country   ENV['COUNTRY']
  latitude  -3.1143
  longitude 55.9527
end
