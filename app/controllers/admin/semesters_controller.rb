class Admin::SemestersController < ApplicationController

  def index
    @semesters = Semester.cronologial
  end


  def new
    @semester = Semester.new
  end


  def create
    @semester = Semester.new(params[:semester])

    if @semester.save
      flash[:success] = "#{@semester.name} created successfully!"

      redirect_to semesters_path
      return
    end

    render :new
  end


  def edit
    @semester = Semester.find(params[:id])
  end


  def update
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
