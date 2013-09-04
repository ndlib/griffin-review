class StreamingController < ApplicationController

  skip_before_filter :authenticate_user!



  def show
    @get_reserve = GetReserve.new(current_user, params)

    validate_token!

    if cookies['_reserves_session'] || !current_user.nil?
      authenticate_user!
      check_view_permissions!(@get_reserve.course)
    end

    headers['Content-Length'] = File.size(@get_reserve.mov_file_path).to_s
    send_file(@get_reserve.mov_file_path, :disposition => 'inline', :type => 'video/quicktime')
  end


  def validate_token!
    if @get_reserve.get_course_token != params[:token]
      raise_404
    end
  end

end
