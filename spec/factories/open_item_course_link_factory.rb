FactoryGirl.define do

  factory :open_item_course_link do

    open_item { FactoryGirl.create(:open_item) }
    open_course { FactoryGirl.create(:open_course) }
  end
end
