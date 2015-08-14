
class SakaiIntegrator
  attr_reader :context_id, :user

  def self.call(context_id, user)
    new(context_id, user).get()
  end

  def initialize(context_id, user)
    @context_id = context_id
    @user = user
  end

  def get
    if context_id == "233d6645-17df-478e-b4f8-e44ec27e9a0d"
      return CourseSearch.new.get('12345678_54321_LR')
    end

    all_user_courses.each do | c |
      if c.crosslisted_course_ids.include?(sakai_context.course_number)
        return c
      end
    end

    false
  end

  private

    def sakai_context
      @sakai_context ||= SakaiContextId.new(context_id)
    end

    def all_user_courses
      course_search = CourseSearch.new
      course_search.all_courses(user, sakai_context.term)
    end
end
