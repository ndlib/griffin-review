class FixElectronicReserves


  def fix!
    Item.update_all('physical_reserve = 1, electronic_reserve = 0', 'type = "BookReserve"')
    Item.update_all('physical_reserve = 0, electronic_reserve = 1', 'type = "BookChapterReserve"')
    Item.update_all('physical_reserve = 0, electronic_reserve = 1', 'type = "JournalReserve"')

    Item.update_all('physical_reserve = 1, electronic_reserve = 1', 'type = "VideoReserve" AND physical_reserve != 1 ')
    Item.update_all('physical_reserve = 1, electronic_reserve = 1', 'type = "AudioReserve" AND physical_reserve != 1 ')

    Item.update_all('physical_reserve = 1, electronic_reserve = 0', 'type = "VideoReserve" AND physical_reserve = 1 ')
    Item.update_all('physical_reserve = 1, electronic_reserve = 0', 'type = "AudioReserve" AND physical_reserve = 1 ')
  end
end
