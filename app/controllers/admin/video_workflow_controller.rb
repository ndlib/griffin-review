class Admin::VideoWorkflowController < AdminController

  respond_to :json, :html

  def full_list
    
    respond_to do |format|
      format.html { render :template => 'admin/video_workflow/list' }
    end

  end

  def requests_by_state

    if (params[:s_val] == 'all')
      @requests = Request.order('needed_by ASC').all
    else
      @requests = Request.where(:workflow_state => params[:s_val]).order('needed_by ASC')
    end

    @type = params[:s_val]
    
    respond_to do |format|
       format.html { render :partial => 'admin/video_workflow/request_list_table' }
    end

  end

  def requests_by_semester

    @requests = Request.where(:semester_id => params[:s_id]).order('needed_by ASC')

    respond_to do |format|
      format.html { render :template => 'admin/video_workflow/list' }
    end

  end
  
  def request_transition
    @request = Request.find(params[:r_id])

    transition_success = true
    if (!params[:trans_val].nil? && !params[:trans_val].empty?)
      transition = params[:trans_val]
      begin
        @request.send("#{transition}!".to_sym)
      rescue
        transition_success = false
      end
    end

    if transition_success
      @request.workflow_state_user = current_user
      @request.workflow_state_change_date = Time.now
      @request.save
    end

    respond_to do |format|
      transition_success ?  format.json { head :ok } : format.json { head :bad_request }
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
    if (!params[:request][:workflow_transition].nil? && !params[:request][:workflow_transition].empty?)
      transition = params[:request][:workflow_transition]
      @request.send("#{transition}!".to_sym)
      @request.workflow_state_user = current_user
      @request.workflow_state_change_date = Time.now
    end

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

  def request_record

    @request = Request.find(params[:request_id])
    
    # LDAP interface
    if (!@request.workflow_state_change_user.nil?)
      ldap = Ldap.new
      ldap.connect
      begin
        @workflow_user = ldap.find('uid', @request.workflow_state_user.username)
      rescue
        @workflow_user = nil
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def requester

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
