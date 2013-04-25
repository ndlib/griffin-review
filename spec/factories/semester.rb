Factory.define :semester do |s|
  s.sequence(:code) { |n| "spring#{n}" }
  s.sequence(:full_name) { |n| "Semester #{n}" }
  s.date_begin Date.today - 3.weeks
  s.date_end Date.today + 4.months
end


Factory.define :previous_semester, :class => "Semester" do | s |
  s.sequence(:code) { |n| "fall#{n}" }
  s.sequence(:full_name) { |n| "Semester #{n}" }
  s.date_begin Date.today - 4.months
  s.date_end Date.today - 3.weeks
end
