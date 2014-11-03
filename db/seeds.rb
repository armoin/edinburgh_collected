# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
city    = 'Edinburgh'
country = 'United Kingdom'
areas   = [
  "Balerno",
  "Blackhall",
  "Bruntsfield",
  "Clermiston",
  "Colinton",
  "Corstorphine",
  "Craigmillar",
  "Cramond",
  "Currie",
  "Dalry",
  "Dean Village",
  "Drumbrae",
  "Duddingston",
  "Fountainbridge",
  "Gilmerton",
  "Gorgie",
  "Granton",
  "Joppa",
  "Kirkliston",
  "Leith",
  "Liberton",
  "Morningside",
  "Muirhouse",
  "New Town",
  "Newhaven",
  "Newington",
  "Old Town",
  "Oxgangs",
  "Piershill",
  "Pilton",
  "Portobello",
  "Ratho",
  "Sighthill",
  "South Queensferry",
  "Stockbridge",
  "Wester Hailes",
]

areas.each do |area|
  Area.create_with(city: city, country: country).find_or_create_by(name: area)
end

categories = [
  "Childhood",
  "Education",
  "Environment",
  "Events",
  "Family Life",
  "Fashion",
  "Food and Drink",
  "Health",
  "Home",
  "Leisure",
  "Places",
  "Sport",
  "Technology",
  "Travel",
  "Work"
]

categories.each do |c|
  Category.find_or_create_by(name: c)
end