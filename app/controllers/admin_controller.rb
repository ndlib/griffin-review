class AdminController < ApplicationController

  before_filter :authenticate_user!
#  load_and_authorize_resource
#  skip_authorize_resource :only => :not_authorized

  def not_authorized

    respond_to do |format|
      format.html
    end

  end

  def user_info

    user_record = User.find(params[:user_id])

    # LDAP interface
    ldap = Ldap.new
    ldap.connect
    @user = ldap.find('uid', user_record.username)

    respond_to do |format|
      format.html { render :json => {
        :first_name => user_record.first_name,
        :last_name => user_record.last_name
      }.to_json }
      format.json { render :json => {
        :first_name => user_record.first_name,
        :last_name => user_record.last_name
      }.to_json }
      format.js
    end
  end

  def index

    @items = OpenItem.currently_used(self.calculate_semester)
    @students = Student.currently_enrolled(self.calculate_semester)
    @courses = Course.currently_available(self.calculate_semester)

    respond_to do |format|
      format.html
      format.xml { render :xml => @courses }
    end

  end

  def new_semester
    @semester = Semester.new
    respond_to do |format|
      format.html { render :template => 'admin/semester/new' }
    end
  end

  def index_semester
    @semesters = Semester.order(:date_begin).all
    respond_to do |format|
      format.html { render :template => 'admin/semester/index' }
    end
  end

  def edit_semester
    @semester = Semester.find(params[:semester_id])
    logger.debug "Semester found: #{@semester.attributes.inspect}"
    respond_to do |format|
      format.html { render :template => 'admin/semester/edit' }
    end
  end

  def create_semester
    @semester = Semester.new(params[:semester])

    respond_to do |format|
      if @semester.save
        format.html { redirect_to semester_url(:semester_id => @semester.id), :notice => 'Semester was successfully created.' }
        format.json { render :json => @semester, :status => :created, :location => semester_url(@semester) }
      else
        format.html { render :action => 'new_semester', :template => 'admin/semester/new' }
        format.json { render :json => @semester.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_semester
    @semester = Semester.find(params[:semester_id])

    respond_to do |format|
      if @semester.update_attributes(params[:semester])
        format.html { redirect_to semester_url(@semester), :notice => 'Semester was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit_semester", :template => 'admin/semester/edit'  }
        format.json { render :json => @semester.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show_semester
    @semester = Semester.find(params[:semester_id])
    respond_to do |format|
      format.html { render :template => 'admin/semester/show' }
    end
  end

  def show_all_semesters
    @semesters = Semester.order(:date_begin).all
    respond_to do |format|
      format.html { render :template => 'admin/semester/list' }
      format.json { render :json => @semesters }
    end
  end

  def show_proximate_semesters
    @semesters = Semester.proximates
    respond_to do |format|
      format.html { render :template => 'admin/semester/list' }
      format.json { render :json => @semesters }
    end
  end

  def all_metadata_attributes
    @metadata_attributes = MetadataAttribute.order(:name).all
    respond_to do |format|
      format.html { render :template => 'admin/metadata_attribute/list' }
      format.json { render :json => @metadata_attributes }
    end
  end

  def new_metadata_attribute
    @metadata_attribute = MetadataAttribute.new
    respond_to do |format|
      format.html { render :template => 'admin/metadata_attribute/new' }
    end
  end

  def edit_metadata_attribute
    @metadata_attribute = MetadataAttribute.find(params[:metadata_attribute_id])
    respond_to do |format|
      format.html { render :template => 'admin/metadata_attribute/edit' }
    end
  end

  def create_metadata_attribute
    @metadata_attribute = MetadataAttribute.new(params[:metadata_attribute])

    respond_to do |format|
      if @metadata_attribute.save
        format.html { redirect_to all_metadata_attribute_url }
        format.json { render :json => @metadata_attribute, :status => :created }
      else
        format.html { render :action => 'new_metadata_attribute', :template => 'admin/metadata_attribute/new' }
        format.json { render :json => @metadata_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_metadata_attribute
    @metadata_attribute = MetadataAttribute.find(params[:metadata_attribute_id])

    respond_to do |format|
      if @metadata_attribute.update_attributes(params[:metadata_attribute])
        format.html { redirect_to all_metadata_attribute_url }
        format.json { head :ok }
      else
        format.html { render :action => "edit_metadata_attribute", :template => 'admin/metadata_attribute/edit'  }
        format.json { render :json => @metadata_attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy_metadata_attribute
    @metadata_attribute = MetadataAttribute.find(params[:metadata_attribute_id])
    @metadata_attribute.destroy

    respond_to do |format|
      format.html { redirect_to all_metadata_attribute_path }
      format.json { head :ok }
    end
  end

  def calculate_semester

    time = Time.new
    year = time.year
    month = time.month

    suffix = ''
    case month
    when 1..5
      suffix = 'S'
    when 6..8
      suffix = 'R'
    when 9..12
      suffix = 'F'
    end

    year.to_s + suffix

  end

end
