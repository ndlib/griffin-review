Factory.define :video do |i|
  i.sequence(:title) { |n| "video_title#{n}" }
  i.sequence(:url) { |n| "video_url#{n}" }
  i.item_type 'video'
end
