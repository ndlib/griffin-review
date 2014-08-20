class UpdateAllReserves < ActiveRecord::Migration
  class Request < ActiveRecord::Base
    belongs_to :item
  end
  class Item < ActiveRecord::Base
  end

  def up
    updates = []
    [:title, :selection_title, :type, :physical_reserve, :electronic_reserve].each do |item_field|
      updates << "requests.item_#{item_field} = items.#{item_field}"
    end
    update_string = updates.join(', ')
    Request.joins(:item).update_all(update_string)
  end

  def down
  end
end
