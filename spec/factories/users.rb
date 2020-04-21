require 'faker'

FactoryBot.define do

  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    display_name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    username { Faker::Internet.user_name }
    created_at { Time.now }
  end

  factory :student, class: 'User' do
    username { "student" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    display_name { Faker::Name.name }
    email { Faker::Internet.safe_email }
  end

  factory :instructor, class: 'User' do
    username { "instructor" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    display_name { Faker::Name.name }
    email { Faker::Internet.safe_email }
  end

  factory :inst_stu, class: 'User' do
    username { "inst_stu" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    display_name { Faker::Name.name }
    email { Faker::Internet.safe_email }
  end

  factory :admin_user, class: 'User' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    display_name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    username { Faker::Internet.user_name }
    admin { true }
  end
end
