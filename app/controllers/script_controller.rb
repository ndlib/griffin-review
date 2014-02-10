class ScriptController < ApplicationController


  def index
    # check_admin_permission!
    #  render :text => ReserveMigrator.new.import!

    id = params[:q]
    response.headers['X-Accel-Redirect'] = "/protected_files/#{id}"

    render :nothing => true
  end
end
