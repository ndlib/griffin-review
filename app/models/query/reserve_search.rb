
class ReserveSearch

  attr_accessor :relation

  def initialize( relation = Request.all )
    @relation = relation
  end


  def get(id, course)
    load_in_reserve(@relation.find(id), course)
  end


  def instructor_reserves_for_course(course)
    @relation.
        includes(:item).
        where('crosslist_id = ? ', course.crosslist_id).
        order('items.title').
        collect { | r | load_in_reserve(r, course)}
  end


  def student_reserves_for_course(course)
    @relation.
        includes(:item).
        where('crosslist_id = ? ', course.crosslist_id).
        where('requests.workflow_state = ?', 'available').
        order('items.title').
        collect { | r | load_in_reserve(r, course)}
  end


  def new_and_inprocess_reserves_for_semester(semester)
    @relation.
        includes(:item).
        where('requests.semester_id  = ?', semester.id).
        where('requests.workflow_state = ? || requests.workflow_state = ?', 'new', 'inprocess').
        order('needed_by').
        collect { | r | load_in_reserve(r, false) }
  end


  def available_reserves_for_semester(semester)
    @relation.
        includes(:item).
        where('requests.semester_id  = ?', semester.id).
        where('requests.workflow_state = ? ', 'available').
        order('needed_by').
        collect { | r | load_in_reserve(r, false) }
  end


  def removed_reserves_for_semester(semester)
    @relation.
        includes(:item).
        where('requests.semester_id  = ?', semester.id).
        where('requests.workflow_state = ? ', 'removed').
        order('needed_by').
        collect { | r | load_in_reserve(r, false) }
  end


  def all_reserves_for_semester(semester)
    @relation.
        includes(:item).
        where('requests.semester_id  = ?', semester.id).
        order('needed_by').
        collect { | r | load_in_reserve(r, false) }
  end


  private

  def load_in_reserve(request, course)
    course = course ? course : request.course

    Reserve.factory(request, course)
  end



end
