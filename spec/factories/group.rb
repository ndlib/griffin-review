Factory.define :group do |f|
  f.sequence(:group_name) { |n| "group_name#{n}" }
end
