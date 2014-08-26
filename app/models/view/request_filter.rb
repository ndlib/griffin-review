class RequestFilter
  attr_accessor :library_filters, :type_filters, :semester_filter
  attr_reader :controller, :user
  delegate :session, :params, to: :controller

  VALID_TYPES = %w(BookReserve BookChapterReserve JournalReserve AudioReserve VideoReserve)
  VALID_LIBRARIES = [ 'hesburgh', 'math', 'chem', 'business', 'architecture', 'engineering']
  RESERVE_TYPES = ["physical","electronic","physical electronic"]
  INSTRUCTOR_RANGE_VALUES = ("A".."Z").to_a

  def initialize(controller, current_user = false)
    @controller = controller

    if current_user
      @user = current_user
    else
      @user = @controller.current_user
    end

    determine_filters
    process_params
  end

  def all_statuses
    [new_in_process_status] + RequestTab.statuses.reject{|s| s == 'all'}
  end

  def all_libraries
    VALID_LIBRARIES
  end

  def all_types
    VALID_TYPES
  end

  def all_reserve_types
    RESERVE_TYPES
  end

  def library_selected?(library)
    library_filters.include?(library)
  end

  def type_selected?(type)
    type_filters.include?(type)
  end

  def status_selected?(status)
    default_status?(status)
  end

  def default_library?(library)
    default_library_filters.include?(library)
  end

  def default_type?(type)
    default_type_filters.include?(type)
  end

  def default_status?(status)
    status == default_status
  end

  def default_status
    new_in_process_status
  end

  def default_reserve_type
    ""
  end

  def all_instructor_range_values
    INSTRUCTOR_RANGE_VALUES
  end

  def default_instructor_range_begin
    all_instructor_range_values.first
  end

  def default_instructor_range_end
    all_instructor_range_values.last
  end

  def save_filter_for_user!
    user.libraries = library_filters
    user.types = type_filters
    user.save!
  end

  private

    def default_library_filters
      @default_library_filters ||= build_default_library_filters
    end

    def default_type_filters
      @default_type_filters ||= build_default_type_filters
    end

    def new_in_process_status
      'new|inprocess'
    end

    def build_default_library_filters
      if user.admin_preferences.present?
        user.libraries
      else
        VALID_LIBRARIES
      end
    end

    def build_default_type_filters
      if user.admin_preferences.present?
        user.types
      else
        VALID_TYPES
      end
    end

    def determine_filters
      if session[:admin_request_filter]
        self.semester_filter = session[:admin_request_filter][:semester]
      else
        self.semester_filter = false
      end

      self.library_filters = default_library_filters
      self.type_filters = default_type_filters
    end


    def process_params
      if params[:admin_request_filter]
        if params[:admin_request_filter][:libraries]
          self.library_filters = params[:admin_request_filter][:libraries]
        end
        if params[:admin_request_filter][:types]
          self.type_filters = params[:admin_request_filter][:types]
        end
        if params[:admin_request_filter][:semester_id]
          if params[:admin_request_filter][:semester_id] != 'false'
            self.semester_filter = params[:admin_request_filter][:semester_id]
          else
            self.semester_filter = false
          end
        end


        save_in_session!
      end
    end


    def save_in_session!
      session[:admin_request_filter] ||= {}
      session[:admin_request_filter][:semester] = semester_filter

    end
end
