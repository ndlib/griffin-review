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
