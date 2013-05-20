class CopyReservesController < ApplicationController


  def create
    check_instructor_permissions!(from_course)
    check_instructor_permissions!(to_course)

    @copy_course_listing = user_course_listing.copy_course_listing(params[:course_id], params[:to_course])

    if !@copy_course_listing.copy_items([])

    end
  end


  protected

    def user_course_listing
      @user_course_listing ||= UserCourseListing.new(current_user)
    end


    def from_course
      @from_course ||= user_course_listing.course(params[:course_id])
    end


    def to_course
      @to_course ||= user_course_listing.course(params[:to_course])
    end

end
