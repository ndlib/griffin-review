class CopyOldReserve


  def initialize(current_user, to_course, old_reserve)
    @user = current_user
    @to_course = to_course
    @old_reserve = old_reserve
    @new_request = Reserve.factory(nil, @to_course)
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
      @new_request.title = @old_reserve.title
      @new_request.creator = "#{@old_reserve.author_firstname} #{@old_reserve.author_lastname}"
      @new_request.journal_title = @old_reserve.journal_name
      @new_request.length = @old_reserve.pages
      @new_request.details = @old_reserve.display_note


      @new_request.overwrite_nd_meta_data = true
      @new_request.workflow_state = 'inprocess'
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
      @new_request.nd_meta_data_id = @old_reserve.sourceId
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
      end
    end



    def copy_video
      @new_request.type = "VideoReserve"
      @new_request.nd_meta_data_id = @old_reserve.sourceId
    end


    def copy_audio
      @new_request.type = "AudioReserve"
      @new_request.nd_meta_data_id = @old_reserve.sourceId
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
