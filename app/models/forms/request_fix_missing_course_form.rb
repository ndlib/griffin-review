class RequestFixMissingCourseForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  include Virtus

  attr_accessor :reserve

  attribute :new_course_id, String

  validates_with  ValidateCourseExists, fields: [:new_course_id]

  def self.build_from_params(controller)
    reserve = ReserveSearch.new.get(controller.params[:id])
    self.new(reserve, controller.params[:request_fix_missing_course_form])
  end


  def initialize(reserve, params)
    @reserve = reserve

    if params
      self.attributes = params
    end
  end


  def old_course_id
    reserve.course_id
  end


  def all_reserves_missing_this_course
    ReserveSearch.new.all_reserves_for_course(reserve.course)
  end

  def title
    reserve.title
  end


  def id
    reserve.id
  end

  def update_course_id!
    if valid?
      all_reserves_missing_this_course.each do | reserve |
        reserve.course = new_course
        reserve.save!
      end
      true
    else
      false
    end
  end

  private

    def new_course
      CourseSearch.new.get(new_course_id)
    end


end
