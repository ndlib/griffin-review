class Admin::RequestsMetaDataController  < ApplicationController

  def edit
    @request = AdminUpdateMetaData.new(current_user, params)
  end


  def update
    @request = AdminUpdateMetaData.new(current_user, params)

    if @request.save_meta_data
      redirect_to requests_path(@request.id, :filter => @request.workflow_state)
    else
      render :edit
    end
  end

end
