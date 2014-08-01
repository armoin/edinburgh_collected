class AssetFactory
  def self.asset_data
    {
      "title"       => "Arthur's Seat",
      "file_type"   => "image",
      "url"         => "/meadows.jpg",
      "description" => "Arthur's Seat is the plug of a long extinct volcano.",
      "year"        => "2014",
      "month"       => "05",
      "day"         => "04",
      "updated_at"  => "2014-06-24T09:55:58.874Z",
      "created_at"  => "2014-06-24T09:55:58.874Z",
      "id"          => "1"
    }
  end

  def self.new_asset_data
    {
      "title"       => "Arthur's Seat",
      "file_type"   => "image",
      "url"         => "/meadows.jpg",
      "description" => "Arthur's Seat is the plug of a long extinct volcano.",
      "year"        => "2014",
      "month"       => "05",
      "day"         => "04",
      "updated_at"  => "2014-06-24T09:55:58.874Z",
      "created_at"  => "2014-06-24T09:55:58.874Z"
    }
  end

  def self.assets_data
    [
      asset_data,
      {
        "title"       => "Castle",
        "file_type"   => "image",
        "url"         => "/castle.jpg",
        "description" => "Edinburgh Castle is still in active use. Situated on the Royal Mile it is very much part of the tourist trail.",
        "year"        => "2014",
        "month"       => "05",
        "day"         => "04",
        "updated_at"  => "2014-06-24T09:55:58.871Z",
        "created_at"  => "2014-06-24T09:55:58.871Z",
        "id"         => "2"
      },
      {
        "title"       => "Cathedral",
        "file_type"   => "image",
        "url"         => "/st_giles.jpg",
        "description" => "St Giles is Edinburgh's Cathedral. Situated on the Royal Mile it is very much part of the tourist trail.",
        "year"        => "2014",
        "month"       => "05",
        "day"         => "04",
        "updated_at"  => "2014-06-24T09:55:58.851Z",
        "created_at"  => "2014-06-24T09:55:58.853Z",
        "id"         => "3"
      }
    ]
  end
end

