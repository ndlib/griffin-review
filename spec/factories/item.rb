FactoryBot.define do
  factory :item do
    title { "title" }
    type { "BookReserve" }
    physical_reserve { true }
  end


  factory :item_book, class: Item do
    title { "book reserve" }
    type { "BookReserve" }
    physical_reserve { true }
    electronic_reserve { false }
  end


  factory :item_book_chapter, class: Item do
    title { "book chapter reserve" }
    type { "BookChapterReserve" }
    pdf { fixture_file_upload(Rails.root.join('spec', 'files', 'test.pdf'), 'application/pdf') }
    physical_reserve { false }
    electronic_reserve { true }
  end

  factory :item_on_order, class: Item do
    title { "book chapter reserve" }
    type { "BookChapterReserve" }
    pdf { fixture_file_upload(Rails.root.join('spec', 'files', 'test.pdf'), 'application/pdf') }
    on_order { true }
    physical_reserve { false }
    electronic_reserve { true }
  end



  factory :item_journal_file, class: Item do
    title { "jourlnal file reserve" }
    type { "JournalReserve" }
    pdf { fixture_file_upload(Rails.root.join('spec', 'files', 'test.pdf'), 'application/pdf') }
    physical_reserve { false }
    electronic_reserve { true }
  end


  factory :item_journal_url, class: Item do
    title { "journal url reserve" }
    type { "JournalReserve" }
    url { "http://www.google.com" }
    physical_reserve { false }
    electronic_reserve { true }
  end


  factory :item_video, class: Item do
    title { "video reserve" }
    type { "VideoReserve" }
    url { "movie.mov" }
    physical_reserve { true }
    electronic_reserve { true }
  end


  factory :item_video_external, class: Item do
    title { "video reserve" }
    type { "VideoReserve" }
    url { "http://www.google.com" }
    physical_reserve { false }
    electronic_reserve { true }
  end

  factory :item_audio, class: Item do
    title { "audio reserve" }
    type { "AudioReserve" }
    url { "audio.mov" }
    physical_reserve { false }
    electronic_reserve { true }
  end


  factory :item_with_bib_record, class: Item do
    title { "book" }
    type { "BookReserve" }
    nd_meta_data_id { "ndu_aleph001368481" }
    physical_reserve { true }
    electronic_reserve { false }
  end

end
