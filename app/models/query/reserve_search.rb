
class ReserveSearch


  def initialize( relation = Request.scoped )
    @relation = relation
  end


  def find_for_course(course)
    @relation.
        join(:item).
        where('reserve_id = ? ', course.reserve_id).
        order('item.title')
  end


end
