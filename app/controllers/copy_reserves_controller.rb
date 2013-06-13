class CopyReservesController < ApplicationController


  def create
    @copy_course_listing = CopyCourseReservesForm.new(current_user, params)

    check_instructor_permissions!(@copy_course_listing.from_course)
    check_instructor_permissions!(@copy_course_listing.to_course)

    if !@copy_course_listing.copy_items

    end
  end

end
