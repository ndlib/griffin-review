Factory.define :semester do |s|
  s.sequence(:code) { |n| "FA1#{n}" }
  s.sequence(:full_name) { |n| "Semester #{n}" }
  s.date_begin Date.today - 3.weeks
  s.date_end Date.today + 4.months
end
