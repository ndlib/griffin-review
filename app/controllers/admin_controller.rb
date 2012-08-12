class AdminController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_authorize_resource :only => :not_authorized

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_not_authorized_url, :alert => exception.message
  end

  def not_authorized

    respond_to do |format|
      format.html
    end

  end

  def index

    @items = Item.currently_used(self.calculate_semester)
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
    @semester = Semester.find(params[:s_id])
    logger.debug "Semester found: #{@semester.attributes.inspect}"
    respond_to do |format|
      format.html { render :template => 'admin/semester/edit' }
    end
  end

  def create_semester
    @semester = Semester.new(params[:semester])

    respond_to do |format|
      if @semester.save
        format.html { redirect_to admin_semester_url(@semester), :notice => 'Semester was successfully created.' }
        format.json { render :json => @semester, :status => :created, :location => admin_semester_url(@semester) }
      else
        format.html { render :action => 'new_semester', :template => 'admin/semester/new' }
        format.json { render :json => @semester.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_semester
    @semester = Semester.find(params[:s_id])

    respond_to do |format|
      if @semester.update_attributes(params[:semester])
        format.html { redirect_to admin_semester_url(@semester), :notice => 'Semester was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit_semester", :template => 'admin/semester/edit'  }
        format.json { render :json => @semester.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show_semester
    @semester = Semester.find(params[:s_id])
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
