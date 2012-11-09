class Admin::OpenVideoController < AdminController

  respond_to :json, :html

  def index

    @open_videos = OpenVideo.currently_used(self.calculate_semester)

    respond_to do |format|
      format.html
      format.xml { render :xml => @open_videos }
    end

  end
  

  def show
    @open_video = OpenVideo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @open_video }
    end
  end

  def new
    @open_video = OpenVideo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @open_video }
    end
  end

  def edit
    @open_video = OpenVideo.find(params[:id])
  end

  def create
    @open_video = OpenVideo.new(params[:open_video])

    uploaded_io = params[:open_video][:upload] 
    if uploaded_io 
      directory = Rails.configuration.reserves_upload_path 
      file_name = uploaded_io.original_filename 
      path = File.join(directory, file_name) 
      File.open(path, "wb") { |f| f.write(uploaded_io.read) } 
    end

    respond_to do |format|
      if @open_video.save
        format.html { redirect_to admin_open_video_url(@open_video), :notice => 'OpenVideo was successfully created.' }
        format.json { render :json => @open_video, :status => :created, :location => @open_video }
      else
        format.html { render :action => "new" }
        format.json { render :json => @open_video.errors, :status => :unprocessable_entity }
      end
    end
  end

  def find_record
    system_number = params[:ils_sysnum]

    # sanitize input
    system_number.strip!

    # compendium gem
    bib = Compendium::Resource.new('bib', system_number).fetch

    # compile the field info
    title = bib.field('title')
    imprint = bib.field('imprint')
    note = bib.field('note')
    note += ' ' + bib.field('summary_note')
    note += ' ' + bib.field('physical_desc')
    note += ' ' + bib.field('performers')
    note += ' ' + bib.field('production_team')
    note += ' ' + bib.field('language_note')
    edition = bib.field('edition')

    respond_to do |format|
      format.html { render :json => { 
        :title => title, 
        :imprint => imprint,
        :note => note,
        :edition => edition
      }.to_json }
      format.json { render :json => { 
        :title => title, 
        :imprint => imprint, 
        :note => note,
        :edition => edition
      }.to_json }
    end

  end

  def update
    @open_video = OpenVideo.find(params[:id])

    respond_to do |format|
      if @open_video.update_attributes(params[:open_video])
        format.html { redirect_to admin_open_video_url(@open_video), :notice => 'OpenVideo was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @open_video.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @open_video = OpenVideo.find(params[:id])
    @open_video.destroy

    respond_to do |format|
      format.html { redirect_to admin_open_video_index_url }
      format.json { head :ok }
    end
  end

end
