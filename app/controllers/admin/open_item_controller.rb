class Admin::OpenItemController < AdminController

  def index
    @open_items = OpenItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @open_items }
    end
  end

  def show
    @open_item = OpenItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @open_item }
    end
  end

  def new
    @open_item = OpenItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @open_item }
    end
  end

  def edit
    @open_item = OpenItem.find(params[:id])
  end

  def create
    @open_item = OpenItem.new(params[:open_item])

    respond_to do |format|
      if @open_item.save
        format.html { redirect_to admin_open_item_url(@open_item), :notice => 'OpenItem was successfully created.' }
        format.json { render :json => @open_item, :status => :created, :location => @open_item }
      else
        format.html { render :action => "new" }
        format.json { render :json => @open_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @open_item = OpenItem.find(params[:id])

    respond_to do |format|
      if @open_item.update_attributes(params[:open_item])
        format.html { redirect_to admin_open_item_url(@open_item), :notice => 'OpenItem was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @open_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @open_item = OpenItem.find(params[:id])
    @open_item.destroy

    respond_to do |format|
      format.html { redirect_to admin_open_item_index_url }
      format.json { head :ok }
    end
  end

end
