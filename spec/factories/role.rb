FactoryGirl.define do
 
  factory :role do
    factory :admin_role do |r|
      r.name "Administrator"
      r.description "Superuser account"
    end

    factory :reserves_admin_role do |r|
      r.name "Reserves Admin"
      r.description "Reserves admin account"
    end
  end

end
