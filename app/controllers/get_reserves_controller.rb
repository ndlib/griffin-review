class GetReservesController < ApplicationController


  def show
    puts params.inspect
    check_view_permissions!(course)

    @get_reserve = GetReserve.new(course.reserve(params[:id]), current_user)

    check_and_process_term_of_service_approval!

    send_or_redirect_if_approved!
  end


  protected

    def user_course_listing
      @user_course_listing ||= UserCourseListing.new(current_user)
    end


    def course
      @course ||= user_course_listing.course(params['course_id'])
    end


    def check_and_process_term_of_service_approval!
      if params['accept_terms_of_service']
        @get_reserve.approve_terms_of_service!
      end
    end


    def send_or_redirect_if_approved!
      puts @get_reserve.approval_required?
      puts @get_reserve.term_of_service_approved
      puts @get_reserve.reserve.approval_required?

      if !@get_reserve.approval_required?
        if @get_reserve.download_listing?
          send_file(@get_reserve.download_file_path)

        elsif @get_reserve.redirect_to_listing?
          redirect_to @get_reserve.redirect_uri
        else
          raise "Attempt to get the resource of a listing that cannot be downloaded or redirected to. "
        end
      end

    end
end
