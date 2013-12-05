res = []
found = []

oi = ""
item = ""

Item.where(type: 'BookChapterReserve').each do | i |
  oi = OpenItem.where('course.term = "2013F"' ).joins(:open_courses).includes(:open_courses).where(title: i.title).first
  if oi.nil?
    res << i
  elsif oi.book_title.present? && oi.title.present?
    i.title = oi.book_title
    i.selection_title = oi.title

    i.save!
    item = i
    found << [ i.id, i.requests.first.course_id, i.title, i.selection_title ] if item.requests.present?
  end
end

