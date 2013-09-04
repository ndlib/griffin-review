require 'spec_helper'

describe InstructorCourseRow do

  before(:each) do
    @fair_use = double(FairUse, id: 1, temporary_approval?: false)
    @course = double(Course, id: 2)
    @reserve = double(Reserve, id: 'id', title: 'title', workflow_state_events: [ 'someevent' ] , workflow_state: 'new', fair_use: @fair_use, course: @course )
    @course_row = InstructorCourseRow.new(@reserve)
  end


  it "generates the correct css class " do
    expect(@course_row.row_css_class).to eq("reserve_#{@reserve.id}")
  end


  describe :workflow_state do

    it "returns the state titleized" do
      expect(@course_row.workflow_state).to eq("New")
    end

    it "returns the special state with a link to the modal if the state is temporary_approval" do
      @fair_use.stub(:temporary_approval?).and_return(true)

      expect(@course_row.workflow_state.include?("Temporarily Approved")).to be_true
      expect(@course_row.workflow_state.include?("<a data-toggle=\"modal\" href=\"#temporarily_available_text\"")).to be_true
    end
  end


  describe :can_delete? do

    it "returns true if the item is in a state that it cannot be deleted  " do
      @reserve.stub(:workflow_state_events).and_return( [:remove] )
      expect(@course_row.can_delete?).to be_true
    end

    it "returns false if item is in a state it can be deleted in " do
      @reserve.stub(:workflow_state_events).and_return( [:other_event] )
      expect(@course_row.can_delete?).to be_false
    end
  end


  describe :delete_link do

    it "returns nothing if the row cannot be deleted" do
      @course_row.stub(:can_delete?).and_return(false)
      expect(@course_row.delete_link).to eq("")
    end


    it "returns a link if the row can be deleted " do
      @course_row.stub(:can_delete?).and_return(true)
      expect(@course_row.delete_link.match(/<a.*href="/)).to be_true
    end


    it "returns a link if the row can be deleted " do
      @course_row.stub(:can_delete?).and_return(true)
      expect(@course_row.delete_link.match(/<a.*data-confirm="/)).to be_true
    end

  end


  describe :delete_sort do

    it "returns removed when a reserve is removed " do
      @course_row.stub(:removed?).and_return(true)
      expect(@course_row.delete_sort).and_return('removed')
    end


    it "returns available if the reserve is not removed" do
      @course_row.stub(:removed?).and_return(false)
      expect(@course_row.delete_sort).and_return('available')
    end
  end


end
