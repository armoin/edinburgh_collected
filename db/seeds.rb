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
  "Places",
  "Sport & Leisure",
  "Technology",
  "Travel",
  "Work"
]

categories.each do |c|
  Category.find_or_create_by(name: c)
end
