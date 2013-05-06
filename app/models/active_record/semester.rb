class Semester < ActiveRecord::Base

  has_many :requests

  validates :code, :full_name, :date_begin, :date_end, :presence => true
  validates :code, :uniqueness => true

  scope :cronologial, order("date_begin desc")
  scope :current, where("date_begin <= ? AND date_end >= ?", Time.zone.now, Time.zone.now)

  # default_scope where('date_begin >= ?', Date.today << 6)

  def name
    full_name
  end

  def self.proximates
    self.where('(date_begin <= ? and date_end <= ?) or (date_begin <= ? and date_end >= ?) or (date_begin <= ? and date_end >= ?)',
               Date.today - 6.months, Date.today - 2.months, # last semester
               Date.today, Date.today, # current semester
               Date.today + 3.months, Date.today + 6.months # next semester
              )
  end

  def pending_requests
    self.requests.where(:workflow_state != 'completed')
  end


  def proximate?
    if self.date_begin <= Date.today && self.date_end <= Date.today
      return false
    elsif self.date_begin >= Date.today + 7.months
      return false
    else
      return true
    end
  end



end
