class RequestTab
  attr_accessor :filter, :library_filters, :type_filters

  VALID_FILTERS = ['new', 'inprocess', 'available', 'on_order', 'removed', 'all']
  VALID_TYPES = %w(BookReserve BookChapterReserve JournalReserve AudioReserve VideoReserve)
  VALID_LIBRARIES = [ 'hesburgh', 'math', 'chem', 'business', 'architecture', 'engeneering']

  def initialize(filter = false)
    #@controller = controller
    #determine_filters
    #process_params

    if !filter
      @filter = 'new'
    else
      @filter = filter
    end


    validate_filter!(@filter)
  end


  def status_filter?(filter)
    validate_filter!(filter)
    @filter == filter
  end


  def status
    @fitler
  end


  def css_class(filter)
    validate_filter!(filter)
    status_filter?(filter) ? 'active' : ''
  end


  def filter
    @filter
  end


  def to_s
    @filter
  end


  def type_filter?(filter)
    types.include?(filter)
  end


  def types
    @type_filter
  end


  def library_filter?(filter)
    libraries.include?(filter)
  end


  def libraries
    @library_filter
  end


  def reserve_status
    @filter
  end

  private

    def validate_filter!(filter)
      if !VALID_FILTERS.include?(filter)
        raise "Invalid filter passed to #{self.class}"
      end
    end


    def determine_filters
      if @controller.session[:admin_request_filter]

        @filter = @controller.session[:admin_request_filter][:status]
        @library_filter = @controller.session[:admin_request_filter][:libraries]
        @type_filter = @controller.session[:admin_request_filter][:types]

      elsif false && @controller.current_user.admin_display_fitlers

      else
        @filter = 'new'
        @library_filter = VALID_LIBRARIES
        @type_filter = VALID_TYPES
      end
    end


    def process_params

      if @controller.params[:admin_request_filter]
        if @controller.params[:admin_request_filter][:status]
          @filter = @controller.params[:admin_request_filter][:status]
        end
        if @controller.params[:admin_request_filter][:libraries]
          @library_filter = @controller.params[:admin_request_filter][:libraries]
        end
        if @controller.params[:admin_request_filter][:types]
          @type_filter = @controller.params[:admin_request_filter][:types]
        end

        save_in_session!
      end
    end


    def save_in_session!
      @controller.session[:admin_request_filter] ||= {}
      @controller.session[:admin_request_filter][:status] = @filter
      @controller.session[:admin_request_filter][:libraries] = @library_filter
      @controller.session[:admin_request_filter][:types] = @types
    end
end
