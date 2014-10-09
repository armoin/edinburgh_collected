task :recreate_versions => :environment do |t, args|
  Photo.find_each do |photo|
    photo.source.recreate_versions!
    photo.categories << Category.first if photo.categories.empty?
    photo.save!
  end
end
