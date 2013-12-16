class ReserveInstructorNotes
  include RailsHelpers

  def initialize(reserve)
    @reserve = reserve
  end


  def display
    if @reserve.type == 'VideoReserve'
      display_video
    else
      display_citation
    end
  end

  private

    def citation
      cite = "<h5>Citation</h5>"
      cite += @reserve.citation.to_s.gsub( %r{http://[^\s<]+} ) do |url|
        "<a target=\"_blank\" href='#{url}'>#{url.truncate(100)}</a>"
      end
      helpers.simple_format(cite)
    end


    def special_instructions
      inst = ""
      if @reserve.note.present?
        inst += "<h5>Special Instructions</h5>"
        inst += helpers.simple_format(@reserve.note)
      end

      helpers.raw inst
    end


    def number_of_copies
      txt = ""
      if @reserve.number_of_copies.present?
        txt += "<p>Number of Copies: #{@reserve.number_of_copies}</p>"
      end

      helpers.raw txt
    end


    def instructor_owns_a_copy
      txt = ""

      if @reserve.type == 'BookReserve' || @reserve.type == 'BookChapterReserve'
        if @reserve.requestor_owns_a_copy
          txt += "<p>Instructor Owns a Copy</p>"
        else
          txt += "<p>Instructor did not Indicate they owned a copy.</p>"
        end
      end

      helpers.raw txt
    end


    def display_citation
      txt = "<div class=\"display_instructor_text\">"

      txt += citation
      txt += special_instructions
      txt += number_of_copies
      txt += instructor_owns_a_copy

      txt += "</div>"

      helpers.raw txt
    end


    def display_video
      txt = "<div class=\"display_instructor_text\">"
      if @reserve.language_track.present?
        txt += "<p>Language Track: #{@reserve.language_track}</p>"
      end
      if @reserve.subtitle_language.present?
        txt +="<p>Subtitle Language: #{@reserve.subtitle_language}</p>"
      end
      if @reserve.length.present?
        txt += "<p>Clips: #{@reserve.length}</p>"
      end


      txt += special_instructions
      txt += "</div>"

      helpers.raw txt
    end


end
