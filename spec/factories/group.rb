FactoryBot.define do
  sequence :group_name do |n|
    "group_name#{n}"
  end
end

# Factory.define :group do |f|
#   f.sequence(:group_name) { |n| "group_name#{n}" }
# end
