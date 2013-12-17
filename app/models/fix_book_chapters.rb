class FixBookChapters
  attr_accessor :skips

  def initialize

  end


  def fix!
    res = []
    found = []

    oi = ""
    item = ""
    @skips = []

    Item.where(type: 'BookChapterReserve').joins(:requests).includes(:requests).where('requests.semester_id = ? ', 3).each do | i |
      term = '2013F'


      ois = OpenItem.where("course.term = '#{term}'" ).joins(:open_courses).includes(:open_courses).where(title: i.title)

      if ois.all.size == 1
        oi = ois.first
        if oi.nil?
          res << i
        elsif oi.book_title.present? && oi.title.present?
          i.title = oi.book_title
          i.selection_title = oi.title

          i.save!
          item = i
          found << [ i.id, i.requests.first.course_id, i.title, i.selection_title ] if item.requests.present?
        end
      elsif ois.size > 1
        @skips << ois
      end

      ois = []
    end

    Item.where(type: 'BookChapterReserve').where("display_length is not null OR display_length != ''").each do | i |
      i.selection_title = i.display_length
      i.save!
    end

    Item.where(type: 'VideoReserve').where("display_length is not null OR display_length != ''").each do | i |
      i.title = "#{i.title} - #{i.display_length}"
      i.save!
    end
  end
end
