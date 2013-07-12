class Admin::SemestersController < ApplicationController

  def index
    check_admin_permission!
    @semesters = Semester.cronologial
  end


  def new
    check_admin_permission!
    @semester = Semester.new
  end


  def create
    check_admin_permission!
    @semester = Semester.new(params[:semester])

    if @semester.save
      flash[:success] = "#{@semester.name} created successfully!"

      redirect_to semesters_path
      return
    end

    render :new
  end


  def edit
    check_admin_permission!
    @semester = Semester.find(params[:id])
  end


  def update
    check_admin_permission!
    @semester = Semester.find(params[:id])

    if @semester.update_attributes(params[:semester])

      flash[:success] = "#{@semester.name} updated successfully!"

      redirect_to semesters_path
      return
    end

    render :edit
  end


  def destroy
  end
end
