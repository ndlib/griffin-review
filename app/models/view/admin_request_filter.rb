class AdminRequestFilter


  def initialize(filter)
    if !filter
      filter = 'new'
    end

    @filter = filter
    validate!
  end


  def new?
    @filter == 'new'
  end


  def inprocess?
    @filter == 'inprocess'
  end


  def complete?
    @filter == 'complete'
  end


  def all?
    @filter == 'all'
  end


  def new_css_class
    new? ? 'active' : ''
  end


  def inprocess_css_class
    inprocess? ? 'active' : ''
  end


  def complete_css_class
    complete? ? 'active' : ''
  end


  def all_css_class
    all? ? 'active' : ''
  end


  def to_s
    @filter
  end


  private

    def validate!
      if !['new', 'inprocess', 'complete', 'all'].include?(@filter)
        raise "Invalid filter passed to #{self.class}"
      end
    end
end
