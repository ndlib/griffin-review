FactoryBot.define do
  factory :basic_metadata do
    metadata_attribute_id { 1 }
    item_id { 1 }
    value { "MyString" }
  end
end
