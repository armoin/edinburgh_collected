class MemoryFactory
  def self.memories
    %w(1 2 3).map{|id| build_memory( memory_data(id) )}
  end

  def self.build_memory(memory_data)
    Memory.new(memory_data)
  end

  def self.file
    file_path = File.join(Rails.root, 'spec', 'fixtures', 'files')
    file_name = 'test.jpg'
    Rack::Test::UploadedFile.new(File.join(file_path, file_name))
  end

  def self.memory_data(id="1")
    {
      "title"       => "Arthur's Seat",
      "file_type"   => "image",
      "source"      => file,
      "description" => "Arthur's Seat is the plug of a long extinct volcano.",
      "year"        => "2014",
      "month"       => "05",
      "day"         => "04",
      "attribution" => "Bobby Tables",
      "updated_at"  => "2014-06-24T09:55:58.874Z",
      "created_at"  => "2014-06-24T09:55:58.874Z",
      "id"          => id
    }
  end

  def self.new_memory_data
    {
      "title"       => "Arthur's Seat",
      "file_type"   => "image",
      "description" => "Arthur's Seat is the plug of a long extinct volcano.",
      "year"        => "2014",
      "month"       => "05",
      "day"         => "04",
      "updated_at"  => "2014-06-24T09:55:58.874Z",
      "created_at"  => "2014-06-24T09:55:58.874Z"
    }
  end

  def self.memories_data
    [
      memory_data,
      {
        "title"       => "Castle",
        "file_type"   => "image",
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

