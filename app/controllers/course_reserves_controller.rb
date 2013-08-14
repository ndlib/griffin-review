class CourseReservesController < ApplicationController

  layout :determine_layout

  def index
    @user_course_show = CourseReserveList.new(current_user, params)
    check_view_permissions!(@user_course_show.course)
  end


  def show
    @get_reserve = GetReserve.new(current_user, params)
    check_view_permissions!(@get_reserve.course)

    check_reserve_can_be_viewed!(@get_reserve)
    check_and_process_term_of_service_approval!(@get_reserve)

    send_or_redirect_if_approved!(@get_reserve)
  end


  def new
    @new_reserve = InstructorReserveRequest.new(current_user, params)

    check_instructor_permissions!(@new_reserve.course)
  end


  def create
    @request_reserve = InstructorReserveRequest.new(current_user, params)

    check_instructor_permissions!(@request_reserve.course)

    if @request_reserve.make_request
      flash[:success] = "<h4>New Request Made</h4><p> Your request has been recieved and will be processed as soon as possible.  </p><a href=\"#{course_reserves_path(@request_reserve.course.id)}\" class=\"btn btn-primary\">I am Done</a>"

      redirect_to new_course_reserve_path(@request_reserve.course.id)
      return
    else

      @new_reserve = InstructorReserveRequest.new(current_user, params)

      flash.now[:error] = "Your form submission has errors in it.  Please correct them and resubmit."
    end

    render :new
  end


  def destroy
    @destroy = InstructorReserveRemoveForm.new(current_user, params)

    @destroy.remove!

    redirect_to course_reserves_path(@destroy.course.id)
  end


  protected


    def check_if_course_can_have_new_reserves!(course)
      if !CreateNewReservesPolicy.new(course).can_create_new_reserves?
        render_404
      end
    end


    def check_and_process_term_of_service_approval!(get_reserve)
      if params['accept_terms_of_service']
        get_reserve.approve_terms_of_service!
      end
    end


    def check_reserve_can_be_viewed!(get_reserve)
      if !get_reserve.link_to_listing?
        render_404
      end
    end


    def send_or_redirect_if_approved!(get_reserve)

      if !get_reserve.approval_required?
        get_reserve.mark_view_statistics

        if get_reserve.download_listing?
          send_file(get_reserve.download_file_path)

        elsif get_reserve.redirect_to_listing?

          if get_reserve.streaming_server_file?
            send_file(get_reserve.mov_file_path, :disposition => 'inline', :type => 'video/quicktime')
            headers['Content-Length'] = File.size(get_reserve.mov_file_path).to_s
          else
            redirect_to get_reserve.redirect_uri
          end
        else
          raise "Attempt to get the resource of a listing that cannot be downloaded or redirected to. "
        end
      end

    end
end
