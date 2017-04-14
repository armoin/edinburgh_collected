desc "Deletes any users that have been marked for deletion for longer than the allowed keep for time"
task :delete_marked_users => :environment do |t, args|
  DeleteUsers.run
end
