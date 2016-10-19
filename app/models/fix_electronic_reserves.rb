class FixElectronicReserves


  def fix!
    Item.where('type = "BookReserve"').update_all('physical_reserve = 1, electronic_reserve = 0')
    Item.where('type = "BookChapterReserve"').update_all('physical_reserve = 0, electronic_reserve = 1')
    Item.where('type = "JournalReserve"').update_all('physical_reserve = 0, electronic_reserve = 1')


    Item.where('type = "VideoReserve" AND physical_reserve = 1 ').update_all('electronic_reserve = 0')
    Item.where('type = "AudioReserve" AND physical_reserve = 1 ').update_all('electronic_reserve = 0')

    Item.where('type = "VideoReserve" AND physical_reserve != 1 ').update_all('physical_reserve = 1, electronic_reserve = 1')
    Item.where('type = "AudioReserve" AND physical_reserve != 1 ').update_all('physical_reserve = 1, electronic_reserve = 1')
  end
end
