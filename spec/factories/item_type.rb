require 'faker'

FactoryBot.define do
  factory :item_type do
    sequence(:name) { |n| "Item Type #{n}" }
    description { Faker::Lorem.paragraph }
  end
end
