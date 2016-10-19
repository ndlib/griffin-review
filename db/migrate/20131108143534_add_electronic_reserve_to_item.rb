class AddElectronicReserveToItem < ActiveRecord::Migration
  def change

    add_column :items, :electronic_reserve, :boolean

    Item.where("type='BookChapterReserve' AND (physical_reserve is null || physical_reserve = 0)").update_all('electronic_reserve = 1')
    Item.where("type='VideoReserve' AND (physical_reserve is null || physical_reserve = 0)").update_all('electronic_reserve = 1')
    Item.where("type='ArticleReserve' AND (physical_reserve is null || physical_reserve = 0)").update_all('electronic_reserve = 1')

  end
end
