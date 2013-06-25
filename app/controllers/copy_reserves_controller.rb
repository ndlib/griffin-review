class CopyReservesController < ApplicationController


  def copy
    puts params.inspect
    @copy_course_listing = CopyCourseReservesForm.new(current_user, params)

    puts @copy_course_listing.from_course.inspect
    puts @copy_course_listing.to_course.inspect
    #check_instructor_permissions!(@copy_course_listing.from_course)
    #check_instructor_permissions!(@copy_course_listing.to_course)

    if !@copy_course_listing.copy_items

    end
  end


  def copy_step1
    @copy_course_listing = CopyCourseReservesForm.new(current_user, params)

    check_instructor_permissions!(@copy_course_listing.to_course)

    if !@copy_course_listing.step1?
      render_404
    end
  end


  def copy_step2
    @copy_course_listing = CopyCourseReservesForm.new(current_user, params)

    check_instructor_permissions!(@copy_course_listing.from_course)
    check_instructor_permissions!(@copy_course_listing.to_course)

    if !@copy_course_listing.step2?
      render_404
    end
  end


end
