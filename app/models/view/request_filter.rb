class RequestFilter
  attr_accessor :libraries, :types, :semester_filter, :reserve_type, :instructor_range_begin, :instructor_range_end
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
    libraries.include?(library)
  end

  def type_selected?(type)
    types.include?(type)
  end

  def status_selected?(status)
    default_status?(status)
  end

  def default_library?(library)
    default_libraries.include?(library)
  end

  def default_type?(type)
    default_types.include?(type)
  end

  def default_status?(status)
    status == default_status
  end

  def default_status
    new_in_process_status
  end

  def default_reserve_type
    user_preference(:reserve_type) || ""
  end

  def all_instructor_range_values
    INSTRUCTOR_RANGE_VALUES
  end

  def default_instructor_range_begin
    user_preference(:instructor_range_begin) || all_instructor_range_values.first
  end

  def default_instructor_range_end
    user_preference(:instructor_range_end) || all_instructor_range_values.last
  end

  def save_filter_for_user!
    user.libraries = libraries
    user.types = types
    user.reserve_type = reserve_type
    user.instructor_range_begin = instructor_range_begin
    user.instructor_range_end = instructor_range_end
    user.save!
  end

  private
    def user_preference(method)
      if user.admin_preferences.present?
        user.send(method)
      else
        nil
      end
    end

    def default_libraries
      user_preference(:libraries) || all_libraries
    end

    def default_types
      user_preference(:types) || all_types
    end

    def new_in_process_status
      'new|inprocess'
    end

    def determine_filters
      if session[:admin_request_filter]
        self.semester_filter = session[:admin_request_filter][:semester]
      else
        self.semester_filter = false
      end

      self.libraries = default_libraries
      self.types = default_types
      self.reserve_type = default_reserve_type
      self.instructor_range_begin = default_instructor_range_begin
      self.instructor_range_end = default_instructor_range_end
    end

    def filter_params
      params[:admin_request_filter]
    end

    def process_params
      if filter_params
        [:libraries, :types, :reserve_type, :instructor_range_begin, :instructor_range_end].each do |method|
          if filter_params[method]
            self.send("#{method}=", filter_params[method])
          end
        end
        if filter_params[:semester_id]
          if filter_params[:semester_id] != 'false'
            self.semester_filter = filter_params[:semester_id]
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
