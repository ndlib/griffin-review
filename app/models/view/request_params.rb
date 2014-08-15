class RequestParams
  attr_accessor :library_filters, :type_filters, :semester_filter

  VALID_TYPES = %w(BookReserve BookChapterReserve JournalReserve AudioReserve VideoReserve)
  VALID_LIBRARIES = [ 'hesburgh', 'math', 'chem', 'business', 'architecture', 'engineering']

  def initialize(controller, user)
    @controller = controller

    @user = user

    determine_filters
  end


  def library_selected?(library)
    @library_filters.include?(library)
  end


  def type_selected?(type)
    @type_filters.include?(type)
  end

  private

    def determine_filters
      if !@user.admin_preferences.nil? && !@user.admin_preferences.empty?
        @library_filters = @user.libraries
        @type_filters    = @user.types
        @semester_filter = false

      else
        @library_filters = VALID_LIBRARIES
        @type_filters    = VALID_TYPES
        @semester_filter = false

      end
    end




end
