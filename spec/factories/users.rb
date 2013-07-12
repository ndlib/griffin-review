require 'faker'

FactoryGirl.define do

  factory :user do |u|
    u.first_name { Faker::Name.first_name }
    u.last_name { Faker::Name.last_name }
    u.display_name { Faker::Name.name }
    u.email { Faker::Internet.safe_email }
    u.username { Faker::Internet.user_name }
  end



  factory :student, class: 'User' do | u |
    u.username "student"
    u.first_name { Faker::Name.first_name }
    u.last_name { Faker::Name.last_name }
    u.display_name { Faker::Name.name }
    u.email { Faker::Internet.safe_email }
  end


  factory :instructor, class: 'User' do | u |
    u.username "instructor"
    u.first_name { Faker::Name.first_name }
    u.last_name { Faker::Name.last_name }
    u.display_name { Faker::Name.name }
    u.email { Faker::Internet.safe_email }
  end


  factory :inst_stu, class: 'User' do | u |
    u.username "inst_stu"
    u.first_name { Faker::Name.first_name }
    u.last_name { Faker::Name.last_name }
    u.display_name { Faker::Name.name }
    u.email { Faker::Internet.safe_email }
  end


  factory :admin_user, class: 'User' do |u|
    u.first_name { Faker::Name.first_name }
    u.last_name { Faker::Name.last_name }
    u.display_name { Faker::Name.name }
    u.email { Faker::Internet.safe_email }
    u.username { Faker::Internet.user_name }
    u.admin true
  end
end
