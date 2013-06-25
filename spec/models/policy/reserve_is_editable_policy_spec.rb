require 'spec_helper'


describe ReserveIsEditablePolicy do


  it "returns true if the semester is current " do
    semester = mock(Semester, :current? => true )
    reserve = mock(Reserve, :semester => semester)

    ReserveIsEditablePolicy.new(reserve).is_editable?.should be_true

  end


  it "returns true if the semester is in the future " do
    semester = mock(Semester, :current? => false, :future? => true )
    reserve = mock(Reserve, :semester => semester)

    ReserveIsEditablePolicy.new(reserve).is_editable?.should be_true

  end

  it "returns false if the reserve semester is not current or future " do
    semester = mock(Semester, :current? => false, :future? => false )
    reserve = mock(Reserve, :semester => semester)

    ReserveIsEditablePolicy.new(reserve).is_editable?.should be_false
  end

end
