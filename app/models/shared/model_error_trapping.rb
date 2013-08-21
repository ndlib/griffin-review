module ModelErrorTrapping

  def self.included(base)
    base.extend(ClassMethods)
  end


  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end


  module ClassMethods
    def render_404
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
