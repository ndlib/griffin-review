class ScriptController < ApplicationController


  def index
    check_admin_permission!
    render :text => SaveRequest.update_all
  end
end
