
class ReserveSearch

  attr_accessor :relation

  def initialize( relation = Request.scoped )
    @relation = relation
  end


  def get(id, course)
    load_in_reserve(@relation.find(id), course)
  end


  def instructor_reserves_for_course(course)
    @relation.
        includes(:item).
        where('course_id = ? ', course.reserve_id).
        order('items.title').
        collect { | r | load_in_reserve(r, course)}
  end


  def student_reserves_for_course(course)
    @relation.
        includes(:item).
        where('course_id = ? ', course.reserve_id).
        where('requests.workflow_state = ?', 'available').
        order('items.title').
        collect { | r | load_in_reserve(r, course)}
  end

  private

  def load_in_reserve(request, course)
    Reserve.factory(request, course)
  end



end
