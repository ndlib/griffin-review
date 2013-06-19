class UserArchiveCourseListingsController < ApplicationController


  def index
    @user_archive_course_listing = UserArchiveCourseListing.new(current_user)
  end


end
