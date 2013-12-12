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
      inst = "<h5>Special Instructions</h5>"
      inst += helpers.simple_format(@reserve.note)

      helpers.raw(inst)
    end


    def has_special_instructions?
      @reserve.note.present?
    end


    def display_citation
      txt = citation

      if has_special_instructions?
        txt += special_instructions
      end

      helpers.raw txt
    end


    def display_video
      txt = ""
      if @reserve.language_track.present?
        txt += "<p>Language Track: #{@reserve.language_track}</p>"
      end
      if @reserve.subtitle_language.present?
        txt +="<p>Subtitle Language: #{@reserve.subtitle_language}</p>"
      end

      if has_special_instructions?
        txt += special_instructions
      end

      helpers.raw txt
    end


end
