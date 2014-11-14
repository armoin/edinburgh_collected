task :recreate_versions => :environment do |t, args|
  Photo.all.each do |photo|
    puts "Updating photo #{photo.id} ..."

    photo.source.recreate_versions!

    if photo.categories.empty?
      puts "Adding a category"
      photo.categories << Category.first
    end

    photo.save!
  end
end
