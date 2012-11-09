Factory.define :open_video do |i|
  i.sequence(:title) { |n| "open_video_title#{n}" }
  i.sequence(:url) { |n| "open_video_url#{n}" }
  i.item_type 'video'
end
