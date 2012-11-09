Factory.define :open_item do |i|
  i.sequence(:title) { |n| "open_item_title#{n}" }
  i.item_type 'book'
end
