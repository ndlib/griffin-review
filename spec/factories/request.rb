require 'faker'

FactoryGirl.define do

  factory :generic_request, :class => Request do
    needed_by Date.today + 2.weeks
    sequence(:title) { |n| "Request Title #{n}" }
    sequence(:course) { |n| "FA12 BUS 300#{n} 01" }
    course_id "adsfdasadfs"
    requestor_netid "netid"
    item FactoryGirl.create(:item)
    note { Faker::Lorem.paragraph }
  end


  factory :new_request, :class => Request do
    needed_by Date.today + 2.weeks
    sequence(:title) { |n| "Request Title #{n}" }
    sequence(:course) { |n| "FA12 BUS 300#{n} 01" }
    course_id "adsfdasadfs"
    requestor_netid "netid"
    item FactoryGirl.create(:item)
    note { Faker::Lorem.paragraph }
    workflow_state "new"
  end

  factory :inprocess_request do
    needed_by Date.today + 2.weeks
    sequence(:title) { |n| "Request Title #{n}" }
    sequence(:course) { |n| "FA12 BUS 300#{n} 01" }
    course_id "adsfdasadfs"
    requestor_netid "netid"
    item FactoryGirl.create(:item)
    note { Faker::Lorem.paragraph }
    workflow_state "new"
  end
end
