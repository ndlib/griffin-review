FactoryBot.define do
 
  factory :role do
    factory :admin_role do
      name { "Administrator" }
      description { "Superuser account" }
    end

    factory :faculty_role do
      name { "Faculty" }
      description { "Faculty account" }
    end

    factory :reserves_admin_role do
      name { "Reserves Admin" }
      description { "Reserves admin account" }
    end

    factory :media_admin_role do
      name { "Media Admin" }
      description { "Media admin account" }
    end

  end

end
