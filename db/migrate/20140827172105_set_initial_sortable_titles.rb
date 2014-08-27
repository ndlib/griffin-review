class SetInitialSortableTitles < ActiveRecord::Migration
  class Request < ActiveRecord::Base
    def primary_title
      if item_selection_title.present?
        item_selection_title
      else
        item_title
      end
    end
  end

  def up
    Request.all.each do |request|
      converted_title = SortableTitleConverter.convert(request.primary_title)
      request.update_attribute(:sortable_title, converted_title)
    end
  end

  def down
  end
end
