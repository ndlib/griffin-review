#!/shared/ruby/187/bin/ruby

require 'rubygems'
require 'logger'
require 'date'
require '/Users/rfox2/Development/griffin/app/models/ldap'

log_path = '/Users/rfox2/Development/griffin/script/'

f = File.new('/Users/rfox2/Development/griffin/script/fall_2012_video_requests_conv.csv', 'r')
log_file = File.open("#{log_path}request_refresh.log", 'w+')
logger = Logger.new(log_file)

count = 1
f.readlines.each do |line|
  # puts line
  record = line.split(/\|/)
  if (!record[3].empty? && record[3] !~ /^\s+$/)
    if count != 1
      ldap = Ldap.new
      ldap.connect
      logger.info("Record #{count}")
      logger.info("==================")
      logger.info("Date Requested: " + Date.parse(record[0]).to_s)
      logger.info("Date Needed: " + Date.parse(record[9]).to_s)
      logger.info("Netid: " + record[1].downcase)
      logger.info("Course: #{record[2]}")
      logger.info("Title: #{record[3]}")
      logger.info("Language: #{record[10]}")
      logger.info("Subtitles: #{record[11]}")
      logger.info("Subtitle Language: #{record[18]}")
      logger.info("CMS: #{record[17]}")
      logger.info("Library Owned: #{record[12]}")
      logger.info("Prior Use: #{record[13]}")
      logger.info("Files: #{record[4]}")
      logger.info("Note: #{record[15]}")
      logger.info("")
    end
    count += 1
  end
end
