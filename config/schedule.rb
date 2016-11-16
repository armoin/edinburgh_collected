# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# Learn more: http://github.com/javan/whenever

every :tuesday, :at => '12pm' do
  rake "delete_marked_users"
end

every :thursday, :at => '12pm' do
  rake "delete_marked_users"
end
