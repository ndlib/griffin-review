class FixElectronicReserves


  def fix!
    Item.update_all('physical_reserve = 1, electronic_reserve = 0', 'type = "BookReserve"')
    Item.update_all('physical_reserve = 0, electronic_reserve = 1', 'type = "BookChapterReserve"')
    Item.update_all('physical_reserve = 0, electronic_reserve = 1', 'type = "JournalReserve"')
    Item.update_all('physical_reserve = 1, electronic_reserve = 1', 'type = "VideoReserve"')
    Item.update_all('physical_reserve = 1, electronic_reserve = 1', 'type = "AudioReserve"')
  end
end
