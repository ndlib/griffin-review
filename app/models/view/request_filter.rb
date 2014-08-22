class RequestFilter
  attr_accessor :library_filters, :type_filters, :semester_filter

  VALID_TYPES = RequestParams::VALID_TYPES
  VALID_LIBRARIES = RequestParams::VALID_LIBRARIES

  def initialize(controller, current_user = false)
    @controller = controller

    if !current_user
      @current_user = @controller.current_user
    else
      @current_user = current_user
    end

    determine_filters
    process_params
  end


  def library_selected?(library)
    @library_filters.include?(library)
  end


  def type_selected?(type)
    @type_filters.include?(type)
  end


  def save_filter_for_user!
    @current_user.libraries = @library_filters
    @current_user.types = @type_filters
    @current_user.save!
  end


  private

    def determine_filters
      if @controller.session[:admin_request_filter]
        @library_filters = @controller.session[:admin_request_filter][:libraries]
        @type_filters    = @controller.session[:admin_request_filter][:types]
        @semester_filter = @controller.session[:admin_request_filter][:semester]

      elsif !@controller.current_user.admin_preferences.nil? && !@controller.current_user.admin_preferences.empty?
        @library_filters = @controller.current_user.libraries
        @type_filters    = @controller.current_user.types
        @semester_filter = false

      else
        @library_filters = VALID_LIBRARIES
        @type_filters    = VALID_TYPES
        @semester_filter = false

      end
    end


    def process_params
      if @controller.params[:admin_request_filter]
        if @controller.params[:admin_request_filter][:libraries]
          @library_filters = @controller.params[:admin_request_filter][:libraries]
        end
        if @controller.params[:admin_request_filter][:types]
          @type_filters = @controller.params[:admin_request_filter][:types]
        end
        if @controller.params[:admin_request_filter][:semester_id]
          if @controller.params[:admin_request_filter][:semester_id] != 'false'
            @semester_filter = @controller.params[:admin_request_filter][:semester_id]
          else
            @semester_filter = false
          end
        end


        save_in_session!
      end
    end


    def save_in_session!
      @controller.session[:admin_request_filter] ||= {}
      @controller.session[:admin_request_filter][:libraries] = @library_filters
      @controller.session[:admin_request_filter][:types] = @type_filters
      @controller.session[:admin_request_filter][:semester] = @semester_filter

    end
end
