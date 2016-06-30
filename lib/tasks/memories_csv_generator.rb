attrs = %w{title source_url description year month day attribution area location latitude longitude}
file_path = "../memories.csv"

CSV.open(file_path, "wb") do |csv|
  csv << attrs

  Photo.publicly_visible.each do |photo|
    csv << attrs.map{|attr| attr == 'area' ? photo.area.try(:name) : photo.send(attr)}
  end
end
