Factory.define :item do |i|
  i.sequence(:title) { |n| "item_title#{n}" }
  i.item_type 'book'
end
