class SemestersController < ApplicationController

  def index
    check_admin_permission!
    @semesters = Semester.chronological
  end


  def new
    check_admin_permission!
    @semester = Semester.new
  end


  def create
    check_admin_permission!
    @semester = Semester.new(semester_params)

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

    if @semester.update_attributes(semester_params)

      flash[:success] = "#{@semester.name} updated successfully!"

      redirect_to semesters_path
      return
    end

    render :edit
  end


  def destroy
    @semester = Semester.find(params[:id])
    @semester.destroy()

    redirect_to semesters_path
  end

  def csv_report
    check_admin_permission!
    se = StatsExporter.new(params[:semester_id])
    semester_code = params[:semester_id] ? Semester.find(params[:semester_id]).code : Semester.current.last.code
    send_data(se.stats_content, :filename => "#{semester_code}.csv")
  end


  private

    def semester_params
      params.require(:semester).permit(:full_name, :code, :movie_directory, :date_begin, :date_end)
    end
end
