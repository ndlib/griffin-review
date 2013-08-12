class RequestsMetaDataController  < ApplicationController

  def edit
    check_admin_permission!
    @request = AdminUpdateMetaData.new(current_user, params)
  end


  def update
    check_admin_permission!
    @request = AdminUpdateMetaData.new(current_user, params)
    if @request.save_meta_data
      flash[:success] = "Meta Data Saved"
      redirect_to request_path(@request.id)
    else
      flash[:error] = @request.errors.full_messages
      render :edit
    end
  end

end
