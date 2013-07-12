class TopicsController < ApplicationController


  def update
    @topic_form = InstructorTopicsForm.new(current_user, params)

    if @topic_form.save_topics
      respond_to do |format|
        format.html { redirect_to(course_reserves_path(course.id)) }
        format.js { render :json => { id: params[:id], topics: @topic_form.current_topics } }
      end
    else
      respond_to do |format|
        format.html { redirect_to(course_reserves_path(course.id), :error => "Server error unable to update topics") }
        format.js { render :json => { id: params[:id], error: "Server error unable to update topics" } }
      end
    end
  end


end
