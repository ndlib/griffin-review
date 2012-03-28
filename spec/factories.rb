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
  i.item_type 'video'
end

