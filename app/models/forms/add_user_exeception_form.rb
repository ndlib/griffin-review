class AddUserExeceptionForm
  include ModelErrorTrapping
  include GetCourse
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
    @course = get_course(params[:course_id])

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
        UserCourseException.create_enrollment_exception!(course.id, course.term, netid)
      elsif role == "instructor"
        UserCourseException.create_instructor_exception!(course.id, course.term, netid)
      end
    end


end
