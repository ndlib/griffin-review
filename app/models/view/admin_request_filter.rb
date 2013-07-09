class AdminRequestFilter


  def initialize(filter)
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


  def inprocess?
    inprocess_filters.include?(@filter)
  end


  def complete?
    @filter == 'available'
  end


  def inprocess_css_class
    inprocess? ? 'active' : ''
  end



  def to_s
    @filter
  end


  private

    def inprocess_filters
      ['inprocess', 'meta_data', 'resource', 'fair_use', 'on_order']
    end

    def validate_filter!(filter)
      if !['new', 'inprocess', 'meta_data', 'resource', 'fair_use', 'on_order', 'available'].include?(filter)
        raise "Invalid filter passed to #{self.class}"
      end
    end
end
