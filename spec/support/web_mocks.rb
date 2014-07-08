require 'rspec/core'

RSpec.configure do |config|
  config.before do
    arthurs_seat = {
      title: "Arthur's Seat",
      file_type: "img",
      url: "/meadows.jpg",
      description: "Arthur's Seat is the plug of a long extinct volcano.",
      updated_at: "2014-06-24T09 : 55 : 58.874Z",
      created_at: "2014-06-24T09 : 55 : 58.874Z",
      _id: "986ff7a7b23bed8283dfc4b979f89b99",
      _rev: "3-818a609da8da9d9296d787b5a78fc01e",
      type: "Asset"
    }
    castle = {
      title: "Castle",
      file_type: "img",
      url: "/castle.jpg",
      description: "Edinburgh Castle is still in active use. Situated on the Royal Mile it is very much part of the tourist trail.",
      updated_at: "2014-06-24T09 : 55 : 58.871Z",
      created_at: "2014-06-24T09 : 55 : 58.871Z",
      _id: "986ff7a7b23bed8283dfc4b979f8aad9",
      _rev: "2-acf04fed22f9fd9d42dc9ba6edbc059c",
      type: "Asset"
    }
    cathedral = {
      title: "Cathedral",
      file_type: "img",
      url: "/st_giles.jpg",
      description: "St Giles is Edinburgh's Cathedral. Situated on the Royal Mile it is very much part of the tourist trail.",
      updated_at: "2014-06-24T09 : 55 : 58.851Z",
      created_at: "2014-06-24T09 : 55 : 58.853Z",
      _id: "986ff7a7b23bed8283dfc4b979f8b8cc",
      _rev: "2-eda16fc8cca927ae37a8780119cd586f",
      type: "Asset"
    }
    @assets = [ arthurs_seat, castle, cathedral ]

    stub_request(:get, "#{ENV['API_HOST']}/assets").
      to_return(:body => @assets.to_json)
    stub_request(:get, "#{ENV['API_HOST']}/assets/986ff7a7b23bed8283dfc4b979f89b99").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.0'}).
         to_return(:status => 200, :body => arthurs_seat.to_json, :headers => {})
  end
end

