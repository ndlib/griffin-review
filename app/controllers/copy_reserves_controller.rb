class CopyReservesController < ApplicationController

  layout :determine_layout

  def copy
    @copy_course_listing = CopyCourseReservesForm.new(current_user, params)

    check_instructor_permissions!(@copy_course_listing.from_course)
    check_instructor_permissions!(@copy_course_listing.to_course)

    if !@copy_course_listing.copy_items

    end
  end


  def copy_step1
    @copy_course_listing = CopyCourseReservesForm.new(current_user, params)

    check_instructor_permissions!(@copy_course_listing.to_course)

    if !@copy_course_listing.step1?
      raise_404("Copy course listing step 1 failed")
    end
  end


  def copy_step2
    @copy_course_listing = CopyCourseReservesForm.new(current_user, params)

    check_instructor_permissions!(@copy_course_listing.from_course)
    check_instructor_permissions!(@copy_course_listing.to_course)

    if !@copy_course_listing.step2?
      raise_404("Copy course listing step 2 failed")
    end
  end


end
