class DocumentationController < ApplicationController

  skip_before_filter :authenticate_user!
  
  layout :determine_layout

  def index
    render
  end

end
