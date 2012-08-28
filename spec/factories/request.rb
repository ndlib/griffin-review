require 'faker'

FactoryGirl.define do

  factory :generic_request, :class => Request do
    needed_by Date.today + 2.weeks
    sequence(:title) { |n| "Request Title #{n}" }
    sequence(:course) { |n| "FA12 BUS 300#{n} 01" }
    repeat_request false
    library_owned false
    language 'English'
    subtitles true
    note { Faker::Lorem.paragraph }
  end

end
