require 'faker'

Factory.define :item_type do |it|
  it.sequence(:name) { |n| "Item Type #{n}" }
  it.description { Faker::Lorem.paragraph }
end
