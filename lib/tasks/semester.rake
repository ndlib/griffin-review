namespace :semester do
  desc "Check for next semester"
  task :check => :environment do
    puts 'find_next_semester'
    sb = SemesterBuild.new
    sb.find_next_semester
  end
end
