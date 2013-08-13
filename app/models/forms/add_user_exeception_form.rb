class AddUserExeceptionForm
  include ModelErrorTrapping
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations


  attr_accessor :course

  attribute :netid, String
  attribute :role, String

  validates :role, :netid, presence: true
  validates :role, inclusion: { in: ['enrollment','instructor'], message: "must be 'enrollment' or 'instructor' " }


  def initialize(current_user, params)
    @course = course_search.get(params[:course_id])

    if params[:add_user_exeception_form]
      self.attributes = params[:add_user_exeception_form]
    end
  end


  def save_user_exception
    if valid?
      persist!
      true
    else
      false
    end
  end


  def valid_roles
    {'Student' => 'enrollment', 'Instructor or TA' => 'instructor'}
  end


  private

    def persist!
      if role == "enrollment"
        course.add_enrollment_exception!(netid)
      elsif role == "instructor"
        course.add_instructor_exception!(netid)
      end
    end


    def get_course(id)
      c = course_search.get(id)

      if c.nil?
        render_404
      end

      c
    end


    def course_search
      @course_search ||= CourseSearch.new
    end
end
