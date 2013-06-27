class UpdateSemesterData < ActiveRecord::Migration
  def up
    Semester.create!( :full_name => 'Summer 2013', :code => '201300', :date_begin => 2.months.ago, :date_end => 1.month.from_now)
  end

  def down
  end
end
