FactoryBot.define do

  factory :open_item_course_link do

    open_item { FactoryBot.create(:open_item) }
    open_course { FactoryBot.create(:open_course) }
  end
end
