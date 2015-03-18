namespace :temp_image do
  desc 'Deletes temporary images that are more than 24 hours old'
  task :delete_old => :environment do |t, args|
    TempImage.where('created_at < ?', 24.hours.ago).destroy_all
  end
end
