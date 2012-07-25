require 'faker'

FactoryGirl.define do
  
  factory :user do |u|
    u.first_name { Faker::Name.first_name }
    u.last_name { Faker::Name.last_name }
    u.display_name { Faker::Name.name }
    u.email { Faker::Internet.safe_email }
    u.username "rfox2"

  end

end
