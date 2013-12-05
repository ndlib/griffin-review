class CopyOldReserve

  GROUP_TO_LIBRARY =  {
        "Admin" => 'hesburgh',
        "Mathematics" => 'math',
        "Chemistry/Physics" => 'chem',
        "Business" => 'business',
        'Architecture' => 'architecture',
        'Engineering' => 'engineering'
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

    # check if the reserve is already in the course

    # check if the reserves should be skipped.

    @new_request.save!

    if @approve_reserve
      approve_fair_use!
    end
    synchronize_meta_data!
    ReserveCheckIsComplete.new(@new_request).check!

    @new_request
  end


  private

    def approve_fair_use!
      fu = @new_request.fair_use
      fu.user = @user
      fu.approve
    end


    def copy_shared_fields!
      # shared data
      @new_request.title   = determine_title(@old_reserve)
      @new_request.selection_title = determine_selection_title(@old_reserve)

      @new_request.creator = "#{@old_reserve.author_firstname} #{@old_reserve.author_lastname}"
      @new_request.journal_title = @old_reserve.journal_name
      @new_request.length  = @old_reserve.pages
      @new_request.details = (@old_reserve.display_note.nil? ? @old_reserve.publisher : @old_reserve.display_note.truncate(250))
      @new_request.library = convert_group_to_library(@old_reserve.group_name)

      @new_request.overwrite_nd_meta_data = true
      @new_request.workflow_state = 'new'
      @new_request.requestor_netid = @user.username
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
      @new_request.nd_meta_data_id = determine_nd_meta_data_id(@new_request)
    end


    def copy_bookchapter
      @new_request.type = "BookChapterReserve"

      if @old_reserve.location.present?
        @new_request.pdf = get_old_file(@old_reserve.location)
      else
        @new_request.url = @old_reserve.url
      end
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
      @new_request.nd_meta_data_id = determine_nd_meta_data_id(@new_request)
    end


    def copy_audio
      @new_request.type = "AudioReserve"
      @new_request.realtime_availability_id = @old_reserve.sourceId
      @new_request.physical_reserve = true
      @new_request.nd_meta_data_id = determine_nd_meta_data_id(@new_request)
    end


    def convert_group_to_library(group)
      if !GROUP_TO_LIBRARY[group]
        raise "Unable to convert the group name, #{group}, in old reserves to the library in the reserves"
      end

      return GROUP_TO_LIBRARY[group]
    end


    def determine_title(reserve)
      if reserve.book_title.present? && reserve.title.present?
        reserve.book_title
      elsif reserve.title.present?
        reserve.title
      elsif reserve.book_title.present?
        reserve.book_title
      else
        "#{reserve.author_firstname} #{reserve.author_lastname}"
      end
    end


    def determine_selection_title(reserve)
      if reserve.book_title.present? && reserve.title.present?
        reserve.title
      else
        ""
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


    def synchronize_meta_data!
      if @new_request.nd_meta_data_id.present?
        @new_request.overwrite_nd_meta_data = false
        ReserveSynchronizeMetaData.new(@new_request).check_synchronized!
      end
    end


    def determine_nd_meta_data_id(request)
      if ['BookReserve', 'VideoReserve', 'AudioReserve'].include?(request.type)
        res = API::PrintReserves.find_by_rta_id_course_id(request.realtime_availability_id, request.course.id)
        if res.empty?
          return ""
        else
          return res.first['bib_id']
        end
      end

      return ""
    end

end
