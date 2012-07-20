require 'factory_girl_rails'

Factory.define :group do |f|
  f.sequence(:group_name) { |n| "group_name#{n}" }
end

Factory.define :item do |i|
  i.sequence(:title) { |n| "item_title#{n}" }
  i.item_type 'book'
end

Factory.define :semester do |s|
  s.sequence(:code) { |n| "FA1#{n}" }
  s.sequence(:full_name) { |n| "Semester #{n}" }
  s.date_begin Date.today - 1.week
  s.date_end Date.today + 5.months
end

Factory.define :video do |i|
  i.sequence(:title) { |n| "video_title#{n}" }
  i.sequence(:url) { |n| "video_url#{n}" }
  i.item_type 'video'
end

Factory.define :user do |u|
  u.first_name "Robert"
  u.last_name "Fox"
  u.display_name "Robert Fox"
  u.email "rfox2@nd.edu"
  u.username "rfox2"
end

Factory.define :admin_user, :class => User do |u|
  u.first_name "Joe"
  u.last_name "Admin"
  u.display_name "Joe Admin"
  u.email "admin@nd.edu"
  u.username "rfox2"
  u.roles [Role.new(:name => 'Administrator', :description => 'Superuser account')]
end

Factory.define :reserves_admin, :class => User do |u|
  u.first_name "Reserves"
  u.last_name "Admin"
  u.display_name "Reserves Admin"
  u.email "radmin@nd.edu"
  u.username "awetheri"
  u.roles [Role.new(:name => 'Reserves Admin', :description => 'Reserves admin account')]
end

