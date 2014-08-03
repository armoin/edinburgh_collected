# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :cc_import => :environment do |t, args|
  ids = [
    4984, 7501, 11134, 1168, 1477, 29112, 24301, 22814, 22819, 21926, 21285,
    21280, 20922, 20850, 20831, 20757, 17236, 17226, 17180, 1167, 12399, 2433, 3071,
    7446, 7606, 7974, 7985, 9509, 10836, 11142, 11201, 11822, 16156, 16173,
    16409, 16421, 16449, 16450, 29734, 29751, 29756, 28906, 28608, 29950, 30542, 20768,
    20866, 20832, 4221, 4257, 4313, 4476, 4457, 4454, 4459, 5688, 23712, 937
  ]
  # ids = [7504]
  # ids = [10862]
  ids.each do |id|
    response = conn.get "/api/v1/items/#{id}?details=full"
    doc = Nokogiri::XML(response.body)
    title = doc.xpath("///field[@name='thumb_title']").first.try(:content)
    year = doc.xpath("///field[@name='search_year']").first.try(:content)
    description = doc.xpath("///field[@name='notes']").first.try(:content)
    image = doc.xpath("//image[contains(@name, 'Web')]").first
    remote_source_url = image['src']
    width = image['width']
    height = image['height']
    asset = Asset.new(
      file_type: 'image',
      title: title,
      year: year,
      description: description,
      width: width,
      height: height
    )
    asset.remote_source_url = remote_source_url
    if asset.save
      puts "#{id} (success)"
    else
      puts "#{id} (failed) #{asset.errors.full_messages}"
    end
  end
end

def conn
  Faraday.new(:url => "http://www.capitalcollections.org.uk") do |faraday|
    faraday.request  :url_encoded
    faraday.adapter  Faraday.default_adapter
  end
end
