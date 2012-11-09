class External::RequestController < ExternalController

  def new
    @r = Request.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @r }
    end
  end

  def create
   
    @r = Request.new(params[:request])
    @r.user = current_user

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
