# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/var/log/whnever_cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever



every 1.day, :at => '2:00 am' do
  rake "repo:sync"
end

every 1.day, :at => '1:00 am' do
  rake "mem:avatar"
end

every 1.day, :at => '3:00 am' do
  rake "repo:cover"
end

every 1.day, :at => '5:00 am' do
  rake "mem:rank"
end



every 4.day, :at => '6:00 am' do
  rake "repo:trend"
end

# run whenever -w
