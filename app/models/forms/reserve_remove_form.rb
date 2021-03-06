class ReserveRemoveForm
  include Virtus.model
  include ModelErrorTrapping


  attribute :reserve, Reserve
  attribute :course, Course


  def initialize(controller)
    self.reserve = load_reserve(controller.params[:id])
  end


  def remove!
    if self.reserve.remove
      self.reserve.save!
    end
  end


  def course
    self.reserve.course
  end


  private

    def reserve_search
      @reserve_search ||= ReserveSearch.new
    end


    def load_reserve(id)
      begin

        reserve_search.get(id)

      rescue ActiveRecord::RecordNotFound => e
        raise_404
      end
    end
end
