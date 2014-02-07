class ScriptController < ApplicationController


  def index
    # check_admin_permission!
    #  render :text => ReserveMigrator.new.import!

    #SaveRequest.update_all

     send_file('/protected_videos')
  end
end
