# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
def create_terms(year)
  summer_begin = Date.parse("#{year}-05-16")
  summer_end = Date.parse("#{year}-08-05")
  fall_end = summer_begin.end_of_year
  spring_end = Date.parse("#{year+1}-05-15")
  Semester.create!( :full_name => "Summer #{year}", :code => "#{year}00", :date_begin => summer_begin, :date_end => summer_end)
  Semester.create!( :full_name => "Fall #{year}", :code => "#{year}10", :date_begin => 1.day.since(summer_end), :date_end => fall_end)
  Semester.create!( :full_name => "Spring #{year}", :code => "#{year}20", :date_begin => 1.day.since(fall_end), :date_end => spring_end)
end

Semester.destroy_all
create_terms(Date.today.year - 1)
create_terms(Date.today.year)
