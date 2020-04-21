FactoryBot.define do
  factory :open_video do
    sequence(:title) { |n| "open_video_title#{n}" }
    sequence(:url) { |n| "open_video_url#{n}" }
    item_type { 'video' }
  end
end
