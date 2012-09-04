desc "Reload the requests from the CSV dump"
task :refresh_requests => :environment do
  log_path = 'log/'

  f = File.new('script/fall_2012_video_requests_conv.csv', 'r')
  log_file = File.open("#{log_path}request_refresh.log", 'w+')
  logger = Logger.new(log_file)

  count = 1
  ldap = Ldap.new
  ldap.connect

  s = Semester.where(:code => 'FA12').first
  
  f.readlines.each do |line|
    # puts line
    record = line.split(/\|/)
    if (!record[3].empty? && record[3] !~ /^\s+$/)
      if count != 1
        user_ldap = ldap.find('uid', record[1].downcase)
        logger.info("UID: " + user_ldap.uid.first)
        user = User.find_or_create_by_username(record[1].downcase, :roles => [personal_affiliation(user_ldap)])
        r = Request.new
        r.semester = s
        if (record[8] =~ /[Cc]omplet/)
          r.workflow_state = 'completed'
        else
          r.workflow_state = 'new'
        end
        logger.info("Record #{count}")
        logger.info("==================")
        logger.info("Date Requested: " + Date.parse(record[0]).to_s)
        r.created_at = Date.parse(record[0])
        logger.info("Date Needed: " + Date.parse(record[9]).to_s)
        r.needed_by = Date.parse(record[9])
        if (!user.nil?)
          logger.info("Netid: " + user.username)
          logger.info("User: " + user.display_name)
        else
          logger.info("Netid: NOT_FOUND")
          logger.info("User: NOT_FOUND")
        end
        r.user = user
        logger.info("Course: #{record[2]}")
        r.course = record[2]
        logger.info("Title: #{record[3]}")
        r.title = record[3]
        logger.info("Language: #{record[10]}")
        r.language = record[10]
        logger.info("Subtitles: #{record[11]}")
        logger.info("Subtitle Language: #{record[18]}")
        r.subtitles = record[11]
        logger.info("CMS: #{record[17]}")
        logger.info("Library Owned: #{record[12]}")
        logger.info("Prior Use: #{record[13]}")
        logger.info("Files: #{record[4]}")
        logger.info("Note: #{record[15]}")
        r.note = record[15]
        logger.info("")
        r.save(:validate => false)
      end
      count += 1
    end
  end
end

def personal_affiliation(user)
  fac_role = Role.where(:name => 'Faculty').first
  stu_role = Role.where(:name => 'Graduate Student').first
  staff_role = Role.where(:name => 'Staff').first
  case user.ndPrimaryAffiliation.first
  when 'Student'
    return stu_role
  when 'Faculty'
    return fac_role
  when 'Staff'
    return staff_role
  end
end

desc "Reset the development database"
task :reset_dev_db => :environment do
  Rails.env = 'development'
  log_path = 'log/'
  log_file = File.open("#{log_path}reset_dev_db.log", 'w+')
  logger = Logger.new(log_file)
  sql = File.open('script/reserves_development.sql', "r")
  new_sql = File.new('script/reserves_development_revised.sql', "w")
  new_sql.close
  sql_new = File.open('script/reserves_development_revised.sql', "w+")
  sql.read.each do |sql_line|
    sql_line.gsub! /\n/, ''
    if (
      !sql_line.nil? &&
      !sql_line.empty? &&
      sql_line !~ /^\s+$/ && 
      sql_line !~ /^\/\*/ &&
      sql_line !~ /^---/ &&
      sql_line !~ /^--/
    )
    sql_new.write(sql_line + "\n")
    end
  end
  sql_new.close
  sql.close
  File.delete('script/reserves_development.sql')
  File.rename('script/reserves_development_revised.sql', 'script/reserves_development.sql')
  sql = File.open('script/reserves_development.sql').read
  sql.split(';').each do |sql_statement|
    sql_statement.gsub! /\n/, ''
    if (
      !sql_statement.nil? &&
      !sql_statement.empty? &&
      sql_statement !~ /^\s+$/
    )
    ActiveRecord::Base.connection().execute(sql_statement)
    logger.info(sql_statement)
    end
  end
end
