

class ReserveStat < ActiveRecord::Base
  belongs_to :user
  belongs_to :request
  belongs_to :item
  belongs_to :semester


  def self.add_statistic!(user, reserve, from_lms)
    ret = self.new( user_id: user.id, request_id: reserve.request.id, item_id: reserve.item.id, semester_id: reserve.semester.id, from_lms: from_lms)
    ret.save!
    ret
  end


  def self.all_request_stats(reserve)
    self.where(request_id: reserve.request.id)
  end


  def self.all_item_stats(reserve)
    self.where(item_id: reserve.item.id)
  end

end
