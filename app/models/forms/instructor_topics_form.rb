class InstructorTopicsForm
  include Virtus
  include ModelErrorTrapping
  include GetCourse

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :reserve, :current_user

  attribute :topics, String

  def initialize(current_user, params)
    @current_user = current_user

    # this code exists to make sure that the sideeffect that is a not found raise is placed somewhere where someone will look.
    begin
      @reserve = get_course(params[:course_id]).reserve(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      raise e
    end

    self.topics = params[:topics]
  end


  def available_topics
    @reserve.course.all_topics
  end


  def topic_checked?(topic)
    @reserve.topics.include?(topic)
  end


  def current_topics
    @reserve.topics
  end


  def save_topics
    if valid?
      persist!
      true
    else
      false
    end
  end


  private

    def persist!
      @reserve.set_topics!(self.topics)
    end


    def get_course(id)
      course_search.get(id)
    end


    def course_search
      @course_search ||= CourseSearch.new
    end


    def validate_inputs!
      if @course.nil?
        render_404
      end
    end



end
