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

    respond_to do |format|
      if @r.save
        format.html { redirect_to admin_video_url(@video), :notice => 'Your request was received and the team has been notified.' }
        format.json { render :json => @r, :status => :created, :location => @r }
      else
        format.html { render :action => "new" }
        format.json { render :json => @r.errors, :status => :unprocessable_entity }
      end
    end
  end

end
