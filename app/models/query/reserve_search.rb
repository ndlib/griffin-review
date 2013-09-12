
class ReserveSearch

  attr_accessor :relation

  def initialize( relation = Request.all )
    @relation = relation
  end


  def get(id, course = nil)
    load_in_reserve(@relation.find(id), course)
  end


  def instructor_reserves_for_course(course)
    @relation.
        includes(:item).
        references(:item).
        where('course_id = ? ', course.id).
        order('items.title').
        collect { | r | load_in_reserve(r, course)}
  end


  def student_reserves_for_course(course)
    @relation.
        includes(:item).
        references(:item).
        where('course_id = ? ', course.id).
        where('requests.workflow_state = ?', 'available').
        order('items.title').
        collect { | r | load_in_reserve(r, course)}
  end


  def admin_requests(status, types, libraries, semester = false)
    search = @relation.
              includes(:item).
              where('requests.semester_id IN(?)', determine_search_semesters(semester)).
              order('needed_by')

    if status != 'all'
      search = search.where('requests.workflow_state = ? ', status)
    end
    if libraries != 'all'
      search = search.where('requests.library IN(?)', libraries)
    end
    if types != 'all'
      search = search.where('items.type IN(?)', types).references(:items)
    end

    search.collect { | r | load_in_reserve(r, false) }
  end


  def reserve_by_bib_for_course(course, bib_id)
    @relation.
      includes(:item).
      references(:item).
      where('requests.course_id = ? ', course.id).
      where('items.nd_meta_data_id = ?', bib_id).
      collect { | r | load_in_reserve(r, false) }.
      first
  end


  private

    def determine_search_semesters(semester)
      (semester ? [semester] : Semester.future_semesters)
    end


    def load_in_reserve(request, course)
      course = course ? course : request.course

      Reserve.factory(request, course)
    end
end
