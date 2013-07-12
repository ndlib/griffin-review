class Admin::RequestsFairUseController  < ApplicationController

  def edit
    check_admin_permission!
    @request = AdminFairUseForm.new(current_user, params)
  end


  def update
    check_admin_permission!
    @request = AdminFairUseForm.new(current_user, params)

    if @request.save_fair_use
      redirect_to requests_path(:filter => @request.workflow_state)
    else
      render :edit
    end
  end

end
