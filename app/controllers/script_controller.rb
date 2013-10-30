class ScriptController < ApplicationController


  def index
    check_admin_permission!
    #  render :text => ReserveMigrator.new.import!

    #SaveRequest.update_all
  end
end
