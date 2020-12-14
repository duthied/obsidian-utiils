#!/usr/bin/env ruby
require 'date'

# copied from https://github.com/mm53bar/obsidian_utils/blob/master/journal.rb

filepath = '/Users/devlon.d/obsidian-vault/daily/' # "#{ENV['HOME']}/Notes/"
today = Date.today
today_name = Time.now.strftime("%A")
filename = today.strftime('%Y-%m-%d.md')
last_year = today.prev_year.strftime('%Y-%m-%d')
this_week = today.strftime('%G-W%V')
this_week_monday = today - (today.cwday-1)
week_filename = this_week + '.md'

# get weather data
weather_raw = `curl -s https://weather.gc.ca/rss/city/on-5_e.xml`
today_weather_raw = weather_raw.split('<entry>').slice(3..4).join
today_weather_list = today_weather_raw.scan(/.*<title>(.*)<\/title>/).flatten

# get daily-cal data
puts "Fetching daily calendar...."

# -f          Format output
# -npn        No property names
# -nc         No calendar names
# -iep,-eep   Include or exclude event properties (value required)
cmd = 'icalBuddy -npn -nc -eep "*" eventsToday'
daily_cal = `#{cmd}`
daily_cal.gsub! "•", "" # remove dots 

# create content
journal_template = <<~JOURNAL
  # Daily entry for #{today_name}, #{today}
  #daily #{today.strftime('%Y-%m-%d')}

  [[the radar]]
  > Review at the start of the day to build my stand up post

  ### Strategy items:
  1.
  2.
  3.
  
  ### Stand up notes
  🗓 {meetings}
  1.
  2.
  3. 

  ### Meeting prep?
  > Are there meetings today or tomorrow that need prep?
  - 

  ### Daily Notes (notes captured through the day)
  - 

  ### Items from your calendar
  #{daily_cal}

  #### Weather
  #{today_weather_list[0]}
  #{today_weather_list[1]}

  #### Health Journal {today.strftime('%Y-%m-%d')}
  -
JOURNAL

# write the file unless it exists
unless File.exist?("#{filepath}#{filename}") 
  File.open("#{filepath}#{filename}", 'a') { |f| f.write "#{journal_template}" }
  puts "Wrote daily template to #{filepath}#{filename}"
else
  puts "Daily template already exists, not writing to #{filepath}#{filename}"
end
