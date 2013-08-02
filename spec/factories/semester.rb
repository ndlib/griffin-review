Factory.define :semester do |s|
  s.sequence(:code) { |n| "current" }
  s.sequence(:full_name) { |n| "Semester #{n}" }
  s.date_begin Date.today - 3.weeks
  s.date_end Date.today + 4.months
end


Factory.define :previous_semester, :class => "Semester" do | s |
  s.sequence(:code) { |n| "previous" }
  s.sequence(:full_name) { |n| "Previous Semester #{n}" }
  s.date_begin Date.today - 4.months
  s.date_end Date.today - 3.weeks
end


Factory.define :next_semester, :class => "Semester" do | s |
  s.sequence(:code) { |n| "next" }
  s.sequence(:full_name) { |n| "Next Semester #{n}" }
  s.date_begin Date.today + 4.months
  s.date_end Date.today + 8.months
end

