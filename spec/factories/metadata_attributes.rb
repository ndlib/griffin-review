Factory.define :metadata_attribute do |ma|
    ma.sequence(:name) { |n| "Meta Name #{n}" }
    ma.definition "Meta Description"
end
