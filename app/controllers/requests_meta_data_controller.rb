class RequestsMetaDataController  < ApplicationController

  def edit
    check_admin_permission!
    @request = AdminUpdateMetaData.new(current_user, params)
  end


  def update
    check_admin_permission!
    @request = AdminUpdateMetaData.new(current_user, params)
    if @request.save_meta_data
      redirect_to requests_path(@request.id, :filter => @request.workflow_state)
    else
      render :edit
    end
  end

end
