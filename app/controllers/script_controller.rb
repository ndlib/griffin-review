class ScriptController < ApplicationController


  def index
    # check_admin_permission!
    #  render :text => ReserveMigrator.new.import!

    #SaveRequest.update_all

    response.headers["X-Accel-Redirect"] = '/protected_videos'
  end
end
