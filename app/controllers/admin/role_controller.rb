class Admin::RoleController < AdminController

  def new
    @role= Role.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @role}
    end
  end

  def index
    @roles = Role.order(:name).all
    respond_to do |format|
      format.html
      format.xml { render :xml => @roles }
    end
  end

  def create
    @role= Role.new(params[:role])

    respond_to do |format|
      if @role.save
        format.html { redirect_to admin_role_url(@role), :notice => 'Role was successfully created.' }
        format.json { render :json => @role, :status => :created, :location => @role}
      else
        format.html { render :action => "new" }
        format.json { render :json => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @role= Role.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @role}
    end
  end

  def destroy
    @role = Role.find(params[:id])
    
    @role.destroy

    respond_to do |format|
      format.html { redirect_to admin_role_index_path }
      format.json { head :ok }
    end
  end

end
