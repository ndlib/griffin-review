class Semester < ActiveRecord::Base

  validates :code, :full_name, :presence => true

  # default_scope where('date_begin >= ?', Date.today << 6)
  
  def self.proximates
    self.where('(date_begin <= ? and date_end <= ?) or (date_begin <= ? and date_end >= ?) or (date_begin <= ? and date_end >= ?)', 
               Date.today - 6.months, Date.today - 2.months, # last semester 
               Date.today, Date.today, # current semester
               Date.today + 3.months, Date.today + 6.months # next semester
              )
  end
  
  def proximate?
    if self.date_begin <= Date.today && self.date_end <= Date.today
      return false
    elsif self.date_begin >= Date.today + 10.months
      return false
    else
      return true
    end
  end
end
