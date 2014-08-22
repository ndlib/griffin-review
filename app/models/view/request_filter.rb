class RequestFilter
  attr_accessor :library_filters, :type_filters, :semester_filter
  attr_reader :controller, :user
  delegate :session, :params, to: :controller

  VALID_TYPES = RequestParams::VALID_TYPES
  VALID_LIBRARIES = RequestParams::VALID_LIBRARIES

  def initialize(controller, current_user = false)
    @controller = controller

    if !current_user
      @user = @controller.current_user
    else
      @user = current_user
    end

    determine_filters
    process_params
  end


  def library_selected?(library)
    library_filters.include?(library)
  end


  def type_selected?(type)
    type_filters.include?(type)
  end


  def save_filter_for_user!
    user.libraries = library_filters
    user.types = type_filters
    user.save!
  end


  private

    def determine_filters
      if session[:admin_request_filter]
        self.library_filters = session[:admin_request_filter][:libraries]
        self.type_filters    = session[:admin_request_filter][:types]
        self.semester_filter = session[:admin_request_filter][:semester]

      elsif user.admin_preferences.present?
        self.library_filters = user.libraries
        self.type_filters    = user.types
        self.semester_filter = false

      else
        self.library_filters = VALID_LIBRARIES
        self.type_filters    = VALID_TYPES
        self.semester_filter = false

      end
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
      session[:admin_request_filter][:libraries] = library_filters
      session[:admin_request_filter][:types] = type_filters
      session[:admin_request_filter][:semester] = semester_filter

    end
end
