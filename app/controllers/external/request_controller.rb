class External::RequestController < ExternalController

  def new
    @r = Request.new
    unless (session[:viewed_modal] == 'viewed')
      session[:viewed_modal] = 'new'
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @r }
    end
  end

  def create
   
    @r = Request.new(params[:request])
    @r.user = current_user

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

    if ((params[:add_another] || params[:final_multiple]) && params[:request][:semester_id].to_i >= 1)
      @multiple_previous_keys = []
      @multiple_previous = []
      if (params[:previous])
        @multiple_previous_keys = params[:previous]
        params[:previous].each do |previous_request_id|
          @multiple_previous.push(Request.find(previous_request_id))
        end
      end
    end

    respond_to do |format|
      if @r.save
        RequestMailer.media_admin_request_notify(@r).deliver
        if (params[:add_another])
          flash.now[:notice] = "The course video request for \"#{@r.title}\" has been received. An additional request can be made by filling out the form below."
          @multiple_previous.push(@r)
          @multiple_previous_keys.push(@r.id)
          @repeat_semester = @r.semester
          @r = Request.new
          format.html { render :action => "new", :location => new_video_request_url(@r) }
        else
          if params[:final_multiple]
            if @multiple_previous.count >=1
              @multiple_previous.push(@r)
              @multiple_previous_keys.push(@r.id)
              @repeat_semester = @r.semester
              format.html { redirect_to video_request_multi_status_path, :flash => { :multiple_previous_keys => @multiple_previous_keys.join(',') } }
            else
              format.html { redirect_to video_request_status_path(@r), :notice => 'Thank you. Your request was received and the team has been notified.' }
              format.json { render :json => @r, :status => :created, :location => @r }
            end
          else
              format.html { redirect_to video_request_status_path(@r), :notice => 'Thank you. Your request was received and the team has been notified.' }
              format.json { render :json => @r, :status => :created, :location => @r }
          end
        end
      else
        @repeat_semester = @r.semester
        flash.now[:error] = "There was a problem creating your most recent video request."
        format.html { render :action => "new" }
        format.json { render :json => @r.errors, :status => :unprocessable_entity }
      end
    end
  end

  def video_request_status
    @r = Request.find(params[:r_id])
    
    respond_to do |format|
      format.html { render :template => 'external/request/status' }
    end
  end

  def video_request_multi_status
    if (flash[:multiple_previous_keys])
      @multiple_previous_keys = flash[:multiple_previous_keys].split(',')
      @multiple_previous = [];
      @multiple_previous_keys.each do |key|
        @multiple_previous.push(Request.find(key))
      end
    end

    respond_to do |format|
      format.html { render :template => 'external/request/multi_status' }
    end
  end

end
