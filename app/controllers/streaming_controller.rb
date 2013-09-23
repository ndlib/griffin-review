class StreamingController < ApplicationController

  skip_before_filter :authenticate_user!


  def show
    @get_reserve = GetReserve.new(self)

    if !valid_token?
      flash[:error] = "Your stream for #{@get_reserve.reserve.title} has expired.  Please reselect it."
      redirect_to course_reserves_path(@get_reserve.reserve.course.id)

      ErrorLog.log_error(self, Exception.new("Token Expired"))
      return
    end

    if cookies['_reserves_session'] || !current_user.nil?
      authenticate_user!
      check_view_permissions!(@get_reserve.course)
    end

    headers['Content-Length'] = File.size(@get_reserve.mov_file_path).to_s
    send_file(@get_reserve.mov_file_path, :disposition => 'inline', :type => 'video/quicktime')
  end


  def test
    headers['X-Frame-Options'] = "ALLOW-FROM SAMEORIGIN"
    authenticate_user!
    render layout: 'video'
  end


  protected

  def valid_token?
    (@get_reserve.get_course_token == params[:token])
  end

end
