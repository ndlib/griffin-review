# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Semester.create!( :full_name => 'Spring 2013', :code => 'spring2013', :date_begin => 2.months.ago, :date_end => 1.month.from_now)
Semester.create!( :full_name => 'Fall 2012', :code => 'fall2013', :date_begin => 5.months.ago, :date_end => 2.months.ago)
