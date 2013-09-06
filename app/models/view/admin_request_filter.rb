class AdminRequestFilter

  VALID_FILTERS = ['new', 'inprocess', 'available', 'on_order', 'removed', 'all']

  def initialize(filter = false)
    if !filter
      filter = 'new'
    end

    @filter = filter
    validate_filter!(@filter)
  end


  def set?(filter)
    validate_filter!(filter)
    @filter == filter
  end


  def css_class(filter)
    validate_filter!(filter)
    set?(filter) ? 'active' : ''
  end


  def to_s
    @filter
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
end
