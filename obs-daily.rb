#!/usr/bin/env ruby
require 'date'
require 'json'

# copied from https://github.com/mm53bar/obsidian_utils/blob/master/journal.rb
# TODO: make env. var.
# filepath = '/Users/devlon.d/obsidian-vault/daily/' # "#{ENV['HOME']}/Notes/"
filepath = '/Users/devlon.d/Library/Mobile Documents/iCloud~md~obsidian/Documents/duthied-ipad/daily/'
today = Date.today
today_name = Time.now.strftime("%A")
filename = today.strftime('%Y-%m-%d.md')
last_year = today.prev_year.strftime('%Y-%m-%d')
this_week = today.strftime('%G-W%V')
this_week_monday = today - (today.cwday-1)
week_filename = this_week + '.md'

# get weather data
# weather_raw = `curl -s https://weather.gc.ca/rss/city/on-5_e.xml`
# today_weather_raw = weather_raw.split('<entry>').slice(3..4).join
# today_weather_list = today_weather_raw.scan(/.*<title>(.*)<\/title>/).flatten

# load content from the razors file
# select random element and return it as a string
def get_razor()
  file = File.read('/Users/devlon.d/src/obsidian_utils-master/razors.json')
  razors = JSON.parse(file)

  random_razor = razors["razors"].sample

  razor_content = random_razor["title"]
  razor_content.concat("\n")

  random_razor["lines"].each do |content|
    razor_content.concat(content["line"])
    razor_content.concat("\n")
  end

  return razor_content
end

# get daily-cal data
puts "Fetching daily calendar...."

# -f          Format output
# -npn        No property names
# -nc         No calendar names
# -iep,-eep   Include or exclude event properties (value required)
cmd = 'icalBuddy -npn -nc -eep "*" eventsToday'
daily_cal = `#{cmd}`
daily_cal.gsub! "•", "" # remove dots 

daily_razor = get_razor()

# create content
journal_template = <<~JOURNAL
  # Daily entry for #{today_name}, #{today}
  #daily #{today.strftime('%Y-%m-%d')}

  [[the radar]]
  > Review at the start of the day to build my stand up post

  [March's Mindfulness Calendar](https://www.actionforhappiness.org/media/980902/march_2021.jpg)

  ### #{daily_razor}

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

  
  -
JOURNAL

# write the file unless it exists
unless File.exist?("#{filepath}#{filename}") 
  File.open("#{filepath}#{filename}", 'a') { |f| f.write "#{journal_template}" }
  puts "Wrote daily template to #{filepath}#{filename}"
else
  puts "Daily template already exists, not writing to #{filepath}#{filename}"
end
