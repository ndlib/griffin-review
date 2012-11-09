Factory.define :metadata_attribute do |ma|
    ma.sequence(:name) { |n| "Meta Name #{n}" }
    ma.metadata_type "technical"
    ma.definition "Meta Description"
end
