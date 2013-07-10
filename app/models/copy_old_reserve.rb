class CopyOldReserve


  def initialize(current_user, to_course, old_reserve)
    @user = current_user
    @to_course = to_course
    @old_reserve = old_reserve
    @new_request = Reserve.factory(nil, @to_course)
  end


  def copy
    # set data from one file to the other
    copy_item_by_type!

    @new_request.workflow_state = 'new'
    @new_request.requestor_netid = @user.username

    @new_request.save!

    @new_request
  end


  private

    def copy_item_by_type!
      case @old_reserve.item_type
      when 'chapter'
        copy_bookchapter
      when 'article'
        "JournalReserve"
      when 'journal'
        "JournalReserve"
      when 'book'
        "BookReserve"
      when 'video'
        "VideoReserve"
      when 'music'
        "AudioReserve"
      else
        raise "type not setup "
      end

    end



    def copy_bookchapter
      @new_request.title = @old_reserve.title
      @new_request.creator = "#{@old_reserve.author_firstname} #{@old_reserve.author_lastname}"
      @new_request.details = @old_reserve.display_note
      @new_request.type = "BookChapterReserve"
      @new_request.overwrite_nd_meta_data = true

      @new_request.pdf = File.open(File.join(old_file_path, @old_reserve.location))
    end


    def old_file_path
      Rails.configuration.path_to_old_files
    end

end
