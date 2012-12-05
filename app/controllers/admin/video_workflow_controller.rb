class Admin::VideoWorkflowController < AdminController

  respond_to :json, :html
  
  autocomplete :video, :name, :full => true, :display_value => :video_display

  def new
    @r = Request.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @r }
    end
  end

  def create

    @r = Request.new(params[:request])

    incoming_note = params[:request][:note]
    incoming_note.sub!(/\s+Media Admin Info/, '')
    incoming_note = incoming_note + "\n\nMedia Admin Info"
    case params[:request][:extent]
    when 'all'
      incoming_note.sub!(/\s+extent:\w+/, '')
      incoming_note = incoming_note + "\nextent:all"
    when 'clips'
      incoming_note.sub!(/\s+extent:\w+/, '')
      incoming_note = incoming_note + "\nextent:clips"
    end

    case params[:request][:cms]
    when 'none'
      incoming_note.sub!(/\s+cms:\w+/, '')
      incoming_note = incoming_note + "\ncms:none"
    when 'vista_concourse'
      incoming_note.sub!(/\s+cms:\w+/, '')
      incoming_note = incoming_note + "\ncms:vista_only"
    when 'sakai_concourse'
      incoming_note.sub!(/\s+cms:\w+/, '')
      incoming_note = incoming_note + "\ncms:sakai_only"
    when 'both_concourse'
      incoming_note.sub!(/\s+cms:\w+/, '')
      incoming_note = incoming_note + "\ncms:sakai_and_vista"
    end
    @r.note = incoming_note

    respond_to do |format|
      if @r.save
        RequestMailer.requester_notify(@r).deliver
        format.html { redirect_to video_request_status_path(@r), :notice => 'Thank you. Your request was received and the team has been notified.' }
        format.json { render :json => @r, :status => :created, :location => @r }
      else
        @repeat_semester = @r.semester
        flash.now[:error] = "There was a problem creating the video request."
        format.html { render :action => "new" }
        format.json { render :json => @r.errors, :status => :unprocessable_entity }
      end
    end
  end

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

  def tech_data

    @request = Request.find(params[:request_id])
    @metadata_attributes = MetadataAttribute.order('name ASC').all
    
    respond_to do |format|
       format.html { render :partial => 'admin/video_workflow/technical_metadata' }
    end

  end

  def requests_by_semester

    @requests = Request.where(:semester_id => params[:s_id]).order('needed_by ASC')

    respond_to do |format|
      format.html { render :template => 'admin/video_workflow/list' }
    end

  end
  
  def request_transition
    @request = Request.find(params[:request_id])

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
    @request = Request.find(params[:request_id])
    @request.destroy

    respond_to do |format|
      format.html { redirect_to video_request_all_path }
      format.json { head :ok }
    end
  end

  def edit
    @request = Request.find(params[:request_id])
    @metadata_attributes = MetadataAttribute.order('name ASC').all
    if (flash[:notice] == 'Adding a technical attribute...' || flash[:notice] == 'Updating technical attributes...')
      @tech_update_return = true
    end
  end

  def destroy_technical_metadata
    @request = Request.find(params[:request_id])
    @tech_metadata = TechnicalMetadata.find(params[:tech_id])
    
    respond_to do |format|
      if @tech_metadata.destroy
        format.json { render :json => {:id => @tech_metadata.id, :status => 'deleted'} }
      else
        format.json { render :json => @tech_metadata.errors, :status => :unprocessable_entity }
      end
    end

  end

  def update
    @request = Request.find(params[:request_id])
    if (params[:request])
      if (!params[:request][:workflow_transition].nil? && !params[:request][:workflow_transition].empty?)
        transition = params[:request][:workflow_transition]
        @request.send("#{transition}!".to_sym)
        @request.workflow_state_user = current_user
        @request.workflow_state_change_date = Time.now
      end
    end

    update_notice = 'Updating technical attributes...'
    if (params[:addtech])
      ma = MetadataAttribute.first
      tm = TechnicalMetadata.new(:vw_id => @request.id, :ma_id => ma.id, :value => 'Please Change');
      tm.save
      update_notice = 'Adding a technical attribute...'
    end

    respond_to do |format|
      if @request.update_attributes(params[:request])
        if (params[:techupdate])
          format.html { redirect_to request_admin_edit_path(:request_id => @request.id), :notice => update_notice }
        else
          format.html { redirect_to request_admin_edit_path(:request_id => @request.id), :notice => 'Request was successfully updated.' }
        end
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @request = Request.find(params[:request_id])
  end

  def request_tech

    @request = Request.find(params[:request_id])
    
    respond_to do |format|
      format.js
    end
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
