class Admin::VideoController < AdminController
  respond_to :json, :html
  
  autocomplete :video, :name, :full => true

  def index
    @videos = Video.order('items.name').all
    respond_to do |format|
      format.html
      format.json { render :json => @videos }
    end
  end

  def new
    @video = Video.new
    @basic_attributes = MetadataAttribute.where(:metadata_type => 'basic').order('name ASC')
    @technical_attributes = MetadataAttribute.where(:metadata_type => 'technical').order('name ASC')
    
    # if video type does not exist, create it
    @video_type = ItemType.where(:name => 'Video').first
    if (@video_type.blank?)
      @new_video_type = ItemType.new(:name => 'Video', :description => 'Either an analog or digital video')
      @new_video_type.save
      @video_type = ItemType.last
    end
    @video.item_type = @video_type
    
    respond_to do |format|
      format.html
    end
  end

  def create
      @video = Video.new(params[:video])
      
      respond_to do |format|
        if @video.save
          format.html { redirect_to admin_video_index_url }
          format.json { render :json => @video, :status => :created }
        else
          format.html { render :action => 'new' }
          format.json { render :json => @video.errors, :status => :unprocessable_entity }
        end
      end
  end
  
  def update
    @video = Video.find(params[:id])
    @basic_attributes = MetadataAttribute.where(:metadata_type => 'basic').order('name ASC')
    @technical_attributes = MetadataAttribute.where(:metadata_type => 'technical').order('name ASC')
    
    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to edit_admin_video_url(@video), :notice => 'Video was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => 'edit' }
        format.json { render :json => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @video = Video.find(params[:id])
    
    respond_to do |format|
      format.html { render :template => 'admin/video/show' }
    end
  end

  def edit
    @video = Video.find(params[:id])
    @basic_attributes = MetadataAttribute.where(:metadata_type => 'basic').order('name ASC')
    @technical_attributes = MetadataAttribute.where(:metadata_type => 'technical').order('name ASC')
    
    respond_to do |format|
      format.html { render :template => 'admin/video/edit' }
    end
  end
  
  def destroy_attribute
    case params[:metadata_type]
    when 'basic' then BasicMetadata.find(params[:metadata_id]).destroy
    when 'technical' then TechnicalMetadata.find(params[:metadata_id]).destroy
    end
    
    respond_to do |format|
      format.html { redirect_to admin_video_url(@video), :notice => 'Video was successfully updated.' }
      format.json { head :ok }
    end
  end

  def destroy
    @video = Video.find(params[:id])
    
    @video.destroy

    respond_to do |format|
      format.html { redirect_to admin_video_index_path }
      format.json { head :ok }
    end
  end
end
