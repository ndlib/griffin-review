FactoryBot.define do
    factory :metadata_attribute do
        sequence(:name) { |n| "Meta Name #{n}" }
        metadata_type { "technical" }
        definition { "Meta Description" }
    end
end
