FactoryGirl.define do

  factory :open_course  do
    term '2005F'
    course_prefix 'prefix'
    course_number 'number'
    course_name 'name'
    section_number '2011F'
    instructor_firstname 'inst_name'
    instructor_lastname 'last_name'
    sequence(:course_id, 1000) {|n| "#{n}" }
  end
end
