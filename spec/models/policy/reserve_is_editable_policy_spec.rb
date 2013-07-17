require 'spec_helper'


describe ReserveIsEditablePolicy do


  it "returns true if the semester is current " do
    semester = double(Semester, :current? => true )
    reserve = double(Reserve, :semester => semester)

    ReserveIsEditablePolicy.new(reserve).is_editable?.should be_true

  end


  it "returns true if the semester is in the future " do
    semester = double(Semester, :current? => false, :future? => true )
    reserve = double(Reserve, :semester => semester)

    ReserveIsEditablePolicy.new(reserve).is_editable?.should be_true

  end

  it "returns false if the reserve semester is not current or future " do
    semester = double(Semester, :current? => false, :future? => false )
    reserve = double(Reserve, :semester => semester)

    ReserveIsEditablePolicy.new(reserve).is_editable?.should be_false
  end

end
