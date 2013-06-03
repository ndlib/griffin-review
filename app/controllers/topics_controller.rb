class TopicsController < ApplicationController


  def update
    @topic_form = InstructorTopicsForm.new(current_user, course.reserve(params[:id]), params)

    if @topic_form.save_topics
      respond_to do |format|
        format.html { redirect_to(course_path(course.id)) }
        format.js { render :json => @topic_form.current_topics }
      end
    else

    end
  end


  private

    def user_course_listing
      @user_course_listing ||= UserCourseListing.new(current_user)
    end


    def course
      @course ||= user_course_listing.course(params['course_id'])
    end
end
