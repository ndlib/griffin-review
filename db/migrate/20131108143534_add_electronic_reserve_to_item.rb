class AddElectronicReserveToItem < ActiveRecord::Migration
  def change

    add_column :items, :electronic_reserve, :boolean

    Item.update_all('electronic_reserve = 1', "type='BookChapterReserve' AND (physical_reserve is null || physical_reserve = 0)")
    Item.update_all('electronic_reserve = 1', "type='VideoReserve' AND (physical_reserve is null || physical_reserve = 0)")
    Item.update_all('electronic_reserve = 1', "type='ArticleReserve' AND (physical_reserve is null || physical_reserve = 0)")

  end
end
