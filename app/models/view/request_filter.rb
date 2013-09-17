class RequestFilter
  attr_accessor :library_filters, :type_filters

  VALID_TYPES = %w(BookReserve BookChapterReserve JournalReserve AudioReserve VideoReserve)
  VALID_LIBRARIES = [ 'hesburgh', 'math', 'chem', 'business', 'architecture', 'engeneering']

  def initialize(controller)
    @controller = controller
    determine_filters
    process_params
  end


  def library_selected?(library)
    @library_filters.include?(library)
  end


  def type_selected?(type)
    @type_filters.include?(type)
  end


  private

    def determine_filters
      if @controller.session[:admin_request_filter]
        @library_filters = @controller.session[:admin_request_filter][:libraries]
        @type_filters    = @controller.session[:admin_request_filter][:types]

      elsif !@controller.current_user.admin_preferences.empty?
        @library_filters = @controller.current_user.libraries
        @type_filters    = @controller.current_user.types

      else
        @library_filters = VALID_LIBRARIES
        @type_filters    = VALID_TYPES

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

        save_in_session!
      end
    end


    def save_in_session!
      @controller.session[:admin_request_filter] ||= {}
      @controller.session[:admin_request_filter][:libraries] = @library_filters
      @controller.session[:admin_request_filter][:types] = @type_filters
    end
end
