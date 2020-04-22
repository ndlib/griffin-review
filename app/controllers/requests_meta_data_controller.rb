class RequestsMetaDataController  < ApplicationController

  def edit
    check_admin_permission!
    @request = AdminUpdateMetaData.build_from_params(self)
  end


  def update
    check_admin_permission!
    @request = AdminUpdateMetaData.build_from_params(self)

    if @request.save_meta_data
      Message.create({'creator'=>current_user.display_name,
        'content'=>'Meta Data changes made.',
        'request_id'=>@request.id})
      flash[:success] = "Meta Data Saved"
      redirect_to request_path(@request.id)
    else
      flash.now[:error] = "Your form submission has errors in it.  Please correct them and resubmit."
      render :edit
    end
  end

end
