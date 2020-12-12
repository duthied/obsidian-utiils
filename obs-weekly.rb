#!/usr/bin/env ruby
require 'date'

def date_of_next(day)
  date  = Date.parse(day)
  delta = date > Date.today ? 0 : 7
  date + delta
end

# copied from https://github.com/mm53bar/obsidian_utils/blob/master/journal.rb

# fill an array with the days of the week, mon->fri starting on the next monday
days_of_the_week = Array.new
week_start = date_of_next("Monday")
days_of_the_week.push(week_start)
for i in 1..4
  days_of_the_week.push(week_start+i)
end

filename = "#{days_of_the_week[0]}".gsub("-", "_") + "-#{days_of_the_week[4].month}_#{days_of_the_week[4].day}.md"
filepath = '/Users/devlon.d/Dropbox/brain-temp/weekly/' # "#{ENV['HOME']}/Notes/"

# create content
weekly_template = <<~WEEKLY
 # Week of #{days_of_the_week[0]} - #{days_of_the_week[4]}
 #weekly

 | Mon (#{days_of_the_week[0].day}) | Tues (#{days_of_the_week[1].day}) | Wed (#{days_of_the_week[2].day}) | Thur (#{days_of_the_week[3].day}) | Fri (#{days_of_the_week[4].day}) |
 | -------- | -------- | ------- | -------- | ------- |
 |          |          |         |          |         |
 |          |          |         |          |         |
 |          |          |         |          |         |
 |          |          |         |          |         |

 ## Monday [[daily/#{days_of_the_week[0]}]]
 --- 
 ##### meeting...
 ##### meeting...


 ## Tuesday [[daily/#{days_of_the_week[1]}]]
 --- 
 ##### meeting...
 ##### meeting...


 ## Wednesday [[daily/#{days_of_the_week[2]}]]
 --- 
 ##### Dev Mgmt
 ##### PlatBU Mgmt
 

 ## Thursday [[daily/#{days_of_the_week[3]}]]
 --- 
 ##### Internal Alarm.com Sync


 ## Friday [[daily/#{days_of_the_week[4]}4]]
 ---

 ##### meetings

WEEKLY

# write the file unless it exists
unless File.exist?("#{filepath}#{filename}") 
  File.open("#{filepath}#{filename}", 'a') { |f| f.write "#{weekly_template}" }
  puts "Wrote weekly template to #{filepath}#{filename}"
else
  puts "Weekly template already exists, not writing to #{filepath}#{filename}"
end
