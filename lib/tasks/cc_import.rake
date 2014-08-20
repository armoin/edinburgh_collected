IDs = [
  7504, 4984, 7501, 11134, 1168, 1477, 29112, 24301, 22814, 22819, 21926, 21285,
  21280, 20922, 20850, 20831, 20757, 17236, 17226, 17180, 1167, 12399, 2433, 3071,
  7446, 7606, 7974, 7985, 9509, 10836, 11142, 11201, 11822, 16156, 16173,
  16409, 16421, 16449, 16450, 29734, 29751, 29756, 28906, 28608, 29950, 30542, 20768,
  20866, 20832, 4221, 4257, 4313, 4476, 4457, 4454, 4459, 5688, 23712, 937
]

class CCAsset
  def initialize(id)
    response = conn.get "/api/v1/items/#{id}?details=full"
    @doc = Nokogiri::XML(response.body)
  end

  def title
    content_for 'thumb_title'
  end

  def year
    content_for 'search_year'
  end

  def description
    content_for 'notes'
  end

  def remote_source_url
    image['src']
  end

  def width
    image['width']
  end

  def height
    image['height']
  end

  private

  def conn
    c = Faraday.new(:url => "http://www.capitalcollections.org.uk") do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
  end

  def content_for(attr_name)
    @doc.xpath("///field[@name='#{attr_name}']").first.try(:content)
  end

  def image
    @doc.xpath("//image[contains(@name, 'Web')]").first
  end
end

task :cc_import => :environment do |t, args|
  abort unless ENV.has_key?('TOKEN')
  IDs.each do |id|
    doc = CCAsset.new(id)
    memory = Memory.new(
      type: 'Image',
      title: doc.title,
      year: doc.year,
      description: doc.description,
      width: doc.width,
      height: doc.height
    )
    memory.remote_source_url = doc.remote_source_url
    if memory.save(ENV['TOKEN'])
      puts "#{id} (success)"
    else
      puts "#{id} (failed) #{memory.errors.full_messages}"
    end
  end
end


