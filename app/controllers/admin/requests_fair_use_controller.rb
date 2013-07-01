class Admin::RequestsFairUseController  < ApplicationController

  def edit
    @request = AdminFairUseForm.new(current_user, params)
  end


  def update
    @request = AdminFairUseForm.new(current_user, params)

    if @request.save_fair_use
      redirect_to requests_path(:filter => @request.workflow_state)
    else
      render :edit
    end
  end

end
