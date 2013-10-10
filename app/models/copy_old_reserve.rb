class CopyOldReserve

  GROUP_TO_LIBRARY =  {
        "Admin" => 'hesburgh',
        "Mathematics" => 'math',
        "Chemistry/Physics" => 'chem',
        "Business" => 'business',
        'Architecture' => 'architecture',
        'Engeneering' => 'engeneering'
      }

  def initialize(current_user, to_course, old_reserve, approve_reserve = false)
    @user = current_user
    @to_course = to_course
    @old_reserve = old_reserve
    @new_request = Reserve.factory(nil, @to_course)
    @approve_reserve = approve_reserve
  end


  def copy
    copy_shared_fields!
    copy_item_by_type!

    @new_request.save!

    @new_request
  end


  private

    def copy_shared_fields!
      # shared data
      @new_request.title   = determine_title(@old_reserve)
      @new_request.creator = "#{@old_reserve.author_firstname} #{@old_reserve.author_lastname}"
      @new_request.journal_title = @old_reserve.journal_name
      @new_request.length  = @old_reserve.pages
      @new_request.details = (@old_reserve.display_note.nil? ? @old_reserve.publisher : @old_reserve.display_note.truncate(250))
      @new_request.library = convert_group_to_library(@old_reserve.group_name)

      @new_request.overwrite_nd_meta_data = true
      @new_request.workflow_state = 'new'
      @new_request.requestor_netid = @user.username

      if @approve_reserve
        @new_request.complete
      end
    end


    def copy_item_by_type!
      case @old_reserve.item_type
      when 'chapter'
        copy_bookchapter
      when 'article'
        copy_journal
      when 'journal'
        copy_journal
      when 'book'
        copy_book
      when 'map'
        copy_book
      when 'video'
        copy_video
      when 'music'
        copy_audio
      else
        raise "type not setup "
      end

    end


    def copy_book
      @new_request.type = "BookReserve"
      @new_request.realtime_availability_id = @old_reserve.sourceId
      @new_request.physical_reserve = true
      @new_request.complete
    end


    def copy_bookchapter
      @new_request.type = "BookChapterReserve"

      @new_request.pdf = get_old_file(@old_reserve.location)
    end


    def copy_journal
      @new_request.type = "JournalReserve"

      if @old_reserve.location.present?
        @new_request.pdf = get_old_file(@old_reserve.location)
      else
        @new_request.url = @old_reserve.url
        @new_request.complete
      end
    end



    def copy_video
      @new_request.type = "VideoReserve"
      @new_request.realtime_availability_id = @old_reserve.sourceId
      @new_request.physical_reserve = true
    end


    def copy_audio
      @new_request.type = "AudioReserve"
      @new_request.realtime_availability_id = @old_reserve.sourceId
      @new_request.physical_reserve = true
    end


    def convert_group_to_library(group)
      if !GROUP_TO_LIBRARY[group]
        raise "Unable to convert the group name, #{group}, in old reserves to the library in the reserves"
      end

      return GROUP_TO_LIBRARY[group]
    end


    def determine_title(reserve)
      if reserve.title.present?
        reserve.title
      elsif reserve.book_title.present?
        reserve.book_title
      else
        "#{reserve.author_firstname} #{reserve.author_lastname}"
      end
    end


    def get_old_file(filename)
      if Rails.env == 'development' || Rails.env == 'test'
        File.open(File.join(Rails.root, 'uploads', 'test.pdf'))
      else

        File.open(File.join(old_file_path, filename))
      end
    end


    def old_file_path
      Rails.configuration.path_to_old_files
    end

end
