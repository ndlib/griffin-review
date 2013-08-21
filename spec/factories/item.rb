FactoryGirl.define do
  factory :item do
    title "title"
    type "BookReserve"
  end


  factory :item_book, class: Item do
    title "book reserve"
    type "BookReserve"
  end


  factory :item_book_chapter, class: Item do
    title "book chapter reserve"
    type "BookChapterReserve"
    pdf { fixture_file_upload(Rails.root.join('spec', 'files', 'test.pdf'), 'application/pdf') }
  end


  factory :item_journal_file, class: Item do
    title "jourlnal file reserve"
    type "JournalReserve"
    pdf { fixture_file_upload(Rails.root.join('spec', 'files', 'test.pdf'), 'application/pdf') }
  end


  factory :item_journal_url, class: Item do
    title "journal url reserve"
    type "JournalReserve"
    url "http://www.google.com"
  end


  factory :item_video, class: Item do
    title "video reserve"
    type "VideoReserve"
    url "movie.mov"
  end


  factory :item_video_external, class: Item do
    title "video reserve"
    type "VideoReserve"
    url "http://www.google.com"
  end

  factory :item_audio, class: Item do
    title "audio reserve"
    type "VideoReserve"
    url "audio.mov"
  end


  factory :item_with_bib_record, class: Item do
    title "book"
    type "BookReserve"
    nd_meta_data_id "ndu_aleph001368481"
  end


end
