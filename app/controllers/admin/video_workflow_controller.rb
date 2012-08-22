class Admin::VideoWorkflowController < AdminController

  respond_to :json, :html

  def full_list
    
    @requests = Request.order('needed_by ASC').all
    
    respond_to do |format|
      format.html { render :template => 'admin/video_workflow/list' }
    end

  end

  def processed_requests
   
    # @requests = Request.where(:request_processed => true).order('needed_by ASC')
    
    respond_to do |format|
      format.html { render :template => 'admin/video_workflow/list' }
    end

  end

  def unprocessed_requests
   
    # @requests = Request.where(:request_processed => false).order('needed_by ASC')
    
    respond_to do |format|
      format.html { render :template => 'admin/video_workflow/list' }
    end

  end

  def requests_by_semester

    @requests = Request.where(:semester_id => params[:s_id]).order('needed_by ASC')

    respond_to do |format|
      format.html { render :template => 'admin/video_workflow/list' }
    end

  end

  def destroy
    @request = Request.find(params[:r_id])
    @request.destroy

    respond_to do |format|
      format.html { redirect_to admin_video_request_all_path }
      format.json { head :ok }
    end
  end

  def edit
    @request = Request.find(params[:r_id])
  end

  def update
    @request = Request.find(params[:r_id])

    respond_to do |format|
      if @request.update_attributes(params[:request])
        format.html { redirect_to admin_video_request_all_url, :notice => 'Request was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @request = Request.find(params[:r_id])
  end

  def requester_info

    requester_record = User.find(params[:user_id])

    # LDAP interface
    ldap = Ldap.new
    ldap.connect
    @requester = ldap.find('uid', requester_record.username)

    respond_to do |format|
      format.html { render :json => { 
        :first_name => requester_record.first_name, 
        :last_name => requester_record.last_name
      }.to_json }
      format.json { render :json => { 
        :first_name => requester_record.first_name, 
        :last_name => requester_record.last_name
      }.to_json }
      format.js
    end
  end

end
