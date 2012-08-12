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

    respond_to do |format|
      if @r.save
        format.html { redirect_to video_request_status_path(@r), :notice => 'Thank you. Your request was received and the team has been notified.' }
        format.json { render :json => @r, :status => :created, :location => @r }
      else
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

end
