class InstructorReserveRemoveForm
  include Virtus
  include ModelErrorTrapping
  include GetCourse


  attribute :reserve, Reserve
  attribute :course, Course


  def initialize(current_user, params)
    @current_user = current_user

    self.course  = get_course(params[:course_id])
    self.reserve = load_reserve(params[:id], @course)
  end


  def remove!
    if self.reserve.remove
      self.reserve.save!
    end
  end


  private

    def reserve_search
      @reserve_search ||= ReserveSearch.new
    end


    def load_reserve(id, course)
      begin

        reserve_search.get(id, course)

      rescue ActiveRecord::RecordNotFound => e
        raise_404
      end
    end
end
