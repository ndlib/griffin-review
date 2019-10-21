class CourseReservesController < ApplicationController

  layout :determine_layout

  def index
    # begin code can be removed after fall 2013
    begin
      @user_course_show = CourseReserveList.build_from_params(self)
    rescue OpenURI::HTTPError => e
      Raven.capture_exception(e)
      lookup = API::CourseSearchApi.course_id(params[:course_id])
      if lookup['section_groups'].first['crosslist_id']
        redirect_to course_reserves_path(lookup['section_groups'].first['crosslist_id'])
        return
      end

      render_404
    end
    check_view_permissions!(@user_course_show.course)
  end


  def show
    @get_reserve = GetReserve.new(self)
    check_view_permissions!(@get_reserve.course)

    check_reserve_can_be_viewed!(@get_reserve)
    check_and_process_term_of_service_approval!(@get_reserve)

    send_or_redirect_if_approved!(@get_reserve)
  end


  def new
    @new_reserve = InstructorReserveRequest.new(self)

    check_instructor_permissions!(@new_reserve.course)
  end


  def create
    @request_reserve = InstructorReserveRequest.new(self)

    check_instructor_permissions!(@request_reserve.course)

    if @request_reserve.make_request

      redirect_to new_course_reserve_path(@request_reserve.course.id)
      return

    else
      @new_reserve = InstructorReserveRequest.new(self)
      render :new
    end
  end


  def destroy
    @destroy = ReserveRemoveForm.new(self)

    check_instructor_permissions!(@destroy.course)

    @destroy.remove!

    if !(permission.current_user_is_admin_in_masquerade? || permission.current_user_is_administrator?)
      ReserveMailer.delete_request_notifier(@destroy.reserve).deliver
    end

    if params[:redirect_to] == 'admin'
      redirect_to request_path(@destroy.reserve.id)
    else
      redirect_to course_reserves_path(@destroy.course.id)
    end
  end


  protected


    def check_if_course_can_have_new_reserves!(course)
      if !CreateNewReservesPolicy.new(course).can_create_new_reserves?
        raise_404("User not allowed to create new reserves")
      end
    end


    def check_and_process_term_of_service_approval!(get_reserve)
      if params['accept_terms_of_service']
        get_reserve.approve_terms_of_service!
      end
    end


    def check_reserve_can_be_viewed!(get_reserve)
      if !get_reserve.link_to_listing?
        raise_404("User not allowed to view reserve")
      end
    end


    def send_or_redirect_if_approved!(get_reserve)

      if !get_reserve.approval_required?
        get_reserve.mark_view_statistics

        if get_reserve.download_listing?
          send_file(get_reserve.download_file_path)

        elsif get_reserve.streaming_server_file?
#            send_file(get_reserve.mov_file_path, :disposition => 'inline', :type => 'video/quicktime')
#            headers['Content-Length'] = File.size(get_reserve.mov_file_path).to_s
          url = {controller: 'streaming', action: 'show', course_id: params[:course_id], token: get_reserve.get_course_token, id: get_reserve.reserve.id}
          redirect_to url
        elsif get_reserve.sipx_redirect?

          url = {controller: 'sipx_redirect', action: 'resource_redirect', course_id: params[:course_id], id: get_reserve.reserve.id}
          redirect_to url
        elsif get_reserve.redirect_to_listing?

          redirect_to get_reserve.redirect_uri
        else
          raise "Attempt to get the resource of a listing that cannot be downloaded or redirected to. "
        end
      end

    end
end
