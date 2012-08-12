FactoryGirl.define do
 
  factory :role do
    factory :admin_role do |r|
      r.name "Administrator"
      r.description "Superuser account"
    end

    factory :faculty_role do |r|
      r.name "Faculty"
      r.description "Faculty account"
    end

    factory :reserves_admin_role do |r|
      r.name "Reserves Admin"
      r.description "Reserves admin account"
    end

    factory :media_admin_role do |r|
      r.name "Media Admin"
      r.description "Media admin account"
    end

  end

end
