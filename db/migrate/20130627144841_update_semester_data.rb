class UpdateSemesterData < ActiveRecord::Migration
  def up

    s = Semester.first
    s.code = '201220'
    s.date_begin = 4.months.ago
    s.date_end = 2.months.from_now
    s.save!

  end

  def down
  end
end
