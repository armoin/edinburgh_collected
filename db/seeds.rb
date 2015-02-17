# set up areas
areas = {
  "Balerno" => {
     :lat => 55.885715,
    :long => -3.342351
  },
  "Blackhall" => {
     :lat => 55.959922,
    :long => -3.256061
  },
  "Bruntsfield" => {
     :lat => 55.9376366,
    :long => -3.1996319
  },
  "Clermiston" => {
     :lat => 55.956795,
    :long => -3.290887
  },
  "Colinton" => {
     :lat => 55.907776,
    :long => -3.2504209
  },
  "Corstorphine" => {
     :lat => 55.943081,
    :long => -3.291449
  },
  "Craigmillar" => {
     :lat => 55.930604,
    :long => -3.143311
  },
  "Cramond" => {
     :lat => 55.975209,
    :long => -3.299634
  },
  "Currie" => {
     :lat => 55.898864,
    :long => -3.311021
  },
  "Dalry" => {
     :lat => 55.9392567,
    :long => -3.2262802
  },
  "Dean Village" => {
     :lat => 55.9522884,
    :long => -3.2182213
  },
  "Drumbrae" => {
     :lat => 55.9425595,
    :long => -3.2931711
  },
  "Duddingston" => {
     :lat => 55.945471,
    :long => -3.136022
  },
  "Fountainbridge" => {
     :lat => 55.9433324,
    :long => -3.208786
  },
  "Gilmerton" => {
     :lat => 55.906569,
    :long => -3.133557
  },
  "Gorgie" => {
     :lat => 55.93632,
    :long => -3.24084
  },
  "Granton" => {
     :lat => 55.982784,
    :long => -3.233393
  },
  "Joppa" => {
     :lat => 55.948429,
    :long => -3.095107
  },
  "Kirkliston" => {
     :lat => 55.956972,
    :long => -3.401411
  },
  "Leith" => {
     :lat => 55.975117,
    :long => -3.166243
  },
  "Liberton" => {
     :lat => 55.913168,
    :long => -3.159998
  },
  "Morningside" => {
     :lat => 55.927715,
    :long => -3.21014
  },
  "Muirhouse" => {
     :lat => 55.974636,
    :long => -3.253994
  },
  "New Town" => {
     :lat => 55.9514271,
    :long => -3.1826393
  },
  "Newhaven" => {
     :lat => 55.980071,
    :long => -3.195142
  },
  "Newington" => {
     :lat => 55.9373537,
    :long => -3.1779132
  },
  "Old Town" => {
     :lat => 55.9414105,
    :long => -3.1476156
  },
  "Oxgangs" => {
     :lat => 55.908215,
    :long => -3.220702
  },
  "Piershill" => {
     :lat => 55.9550487,
    :long => -3.1422696
  },
  "Pilton" => {
     :lat => 55.973794,
    :long => -3.238533
  },
  "Portobello" => {
     :lat => 55.952872,
    :long => -3.113962
  },
  "Ratho" => {
     :lat => 55.921772,
    :long => -3.383983
  },
  "Sighthill" => {
     :lat => 55.921709,
    :long => -3.286809
  },
  "South Queensferry" => {
     :lat => 55.990003,
    :long => -3.399045
  },
  "Stockbridge" => {
     :lat => 55.9578822,
    :long => -3.2087722
  },
  "Wester Hailes" => {
     :lat => 55.91431,
    :long => -3.28434
  }
}

areas.each do |name, coords|
  Area.create_with(city: CITY, country: COUNTRY).find_or_create_by(name: name, latitude: coords[:lat], longitude: coords[:long])
end


# set up categories
categories = [
  "Animals",
  "Childhood",
  "Daily Life",
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


# Setup an admin user
if ENV['CREATE_DEFAULT_ADMIN_USER']
  
  # PLEASE NOTE: you will need to setup a DEFAULT_ADMIN_USER_PASSWORD in config/application.yml
  admin_user_details = {
    first_name:       'Default',
    last_name:        'Admin',
    screen_name:      'Default Admin',
    email:            "admin_#{CITY.downcase}@example.com",
    accepted_t_and_c: true
  }
  admin_user = User.find_or_initialize_by(admin_user_details)
  admin_user.password = ENV['DEFAULT_ADMIN_USER_PASSWORD']
  admin_user.password_confirmation = ENV['DEFAULT_ADMIN_USER_PASSWORD']
  admin_user.is_admin = true
  begin
    admin_user.save!
    admin_user.activate!
  rescue ActiveRecord::RecordInvalid
    puts "Please assign a valid password to DEFAULT_ADMIN_USER_PASSWORD in config/application.yml and run again."
  end

end
