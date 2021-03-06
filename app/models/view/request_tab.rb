class RequestTab
  attr_accessor :filter, :library_filters, :type_filters

  VALID_FILTERS = ['new', 'inprocess', 'onhold', 'awaitinginfo', 'on_order', 'available', 'removed', 'all', 'not_in_aleph']

  def initialize(filter = false)
    if !filter
      @filter = 'all'
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

  def self.statuses
    VALID_FILTERS
  end

  private

    def validate_filter!(filter)
      if !VALID_FILTERS.include?(filter)
        raise "Invalid filter, #{filter}, passed to #{self.class}"
      end
    end

end
