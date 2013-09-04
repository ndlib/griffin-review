class ErrorsController < ApplicationController
  include ErrorHelper
  
  layout :determine_layout

  def index
    check_admin_permission!
    @errors = ErrorLog.errors
  end


  def show
    check_admin_permission!

    @error = ErrorLog.find(params[:id])
  end

end
