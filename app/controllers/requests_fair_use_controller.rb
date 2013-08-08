class RequestsFairUseController  < ApplicationController

  def edit
    check_admin_permission!
    @request = AdminFairUseForm.new(current_user, params)
  end


  def update
    check_admin_permission!
    @request = AdminFairUseForm.new(current_user, params)

    if @request.save_fair_use
      flash[:success] = "Fair Use Saved"
      redirect_to requests_path(@request.id)
    else
      render :edit
    end
  end

end
