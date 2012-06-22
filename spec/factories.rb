require 'factory_girl_rails'

Factory.define :group do |f|
  f.sequence(:group_name) { |n| "group_name#{n}" }
end

Factory.define :item do |i|
  i.sequence(:title) { |n| "item_title#{n}" }
  i.item_type 'book'
end

Factory.define :video do |i|
  i.sequence(:title) { |n| "video_title#{n}" }
  i.sequence(:url) { |n| "video_url#{n}" }
  i.item_type 'video'
end

Factory.define :user do |u|
  u.first_name "Robert"
  u.last_name "Fox"
  u.email "rfox2@nd.edu"
  u.username "rfox2"
end

