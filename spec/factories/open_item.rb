FactoryBot.define do
  factory :open_item do
    sequence(:title) { |n| "open_item_title#{n}" }
    item_type { 'book' }
  end
end
