class Item < OpenReserves
  self.table_name = 'item'
  self.primary_key = 'item_id'

  validates :title, :presence => true, :allow_nil => false
  validates :item_type, :presence => true, :inclusion => { :in => %w(article chapter book video music map journal mixed computer file) }
end
