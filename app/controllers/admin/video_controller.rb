class Admin::VideoController < AdminController

  respond_to :json, :html

  def index

    @videos = Video.currently_used(self.calculate_semester)

    respond_to do |format|
      format.html
      format.xml { render :xml => @videos }
    end

  end
  

  def show
    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @video }
    end
  end

  def new
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @video }
    end
  end

  def edit
    @video = Video.find(params[:id])
  end

  def create
    @video = Video.new(params[:video])

    uploaded_io = params[:video][:upload] 
    if uploaded_io 
      directory = Rails.configuration.reserves_upload_path 
      file_name = uploaded_io.original_filename 
      path = File.join(directory, file_name) 
      File.open(path, "wb") { |f| f.write(uploaded_io.read) } 
    end

    respond_to do |format|
      if @video.save
        format.html { redirect_to admin_video_url(@video), :notice => 'Video was successfully created.' }
        format.json { render :json => @video, :status => :created, :location => @video }
      else
        format.html { render :action => "new" }
        format.json { render :json => @video.errors, :status => :unprocessable_entity }
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
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to admin_video_url(@video), :notice => 'Video was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to admin_video_index_url }
      format.json { head :ok }
    end
  end

end
