class ErrorsController < ApplicationController
  def error_404
    @not_found_path = params[:not_found]
  end

  def error_500
  end


  def index
    check_admin_permission!
    @errors = ErrorLog.errors
  end


  def show
    check_admin_permission!

    @error = ErrorLog.find(params[:id])
  end


end
