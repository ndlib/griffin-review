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
    extent 'all'
    cms 'vista_concourse'
    note { Faker::Lorem.paragraph }
  end

  factory :administrative_request, :class => AdministrativeRequest do
    needed_by Date.today + 2.weeks
    sequence(:title) { |n| "Request Title #{n}" }
    sequence(:course) { |n| "FA12 BUS 300#{n} 01" }
    repeat_request false
    library_owned false
    language 'English'
    subtitles true
    extent 'all'
    user_name Faker::Name.name
    cms 'vista_concourse'
    note { Faker::Lorem.paragraph }
  end

end
