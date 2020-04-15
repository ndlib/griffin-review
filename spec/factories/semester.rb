FactoryBot.define do
  factory :semester do
    sequence(:code) { |n| "current#{n}" }
    sequence(:full_name) { |n| "Semester #{n}" }
    date_begin { Date.today - 3.weeks }
    date_end { Date.today + 4.months }
  end

  factory :previous_semester, :class => "Semester" do
    sequence(:code) { |n| "previous" }
    sequence(:full_name) { |n| "Previous Semester #{n}" }
    date_begin { Date.today - 4.months }
    date_end { Date.today - 3.weeks }
  end

  factory :next_semester, :class => "Semester" do
    sequence(:code) { |n| "next" }
    sequence(:full_name) { |n| "Next Semester #{n}" }
    date_begin { Date.today + 4.months }
    date_end { Date.today + 8.months }
  end
end
