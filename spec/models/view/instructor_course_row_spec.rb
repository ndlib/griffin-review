require 'spec_helper'

describe InstructorCourseRow do

  before(:each) do
    @fair_use = double(FairUse, id: 1, temporary_approval?: false)
    @course = double(Course, id: 2)
    @reserve = double(Reserve, id: 'id', title: 'title', workflow_state_events: [ 'someevent' ] , workflow_state: 'new', fair_use: @fair_use, course: @course )
    @user = double(User, admin?: false)
    @controller = double(ApplicationController, current_user: @user)
    @course_row = InstructorCourseRow.new(@reserve, @controller)
  end


  it "generates the correct css class " do
    expect(@course_row.row_css_class).to eq("reserve_#{@reserve.id}")
  end


  describe :workflow_state do

    it "returns in process if the state is new" do
      @reserve.stub(:workflow_state).and_return('new')
      expect(@course_row.workflow_state).to eq("In Process")
    end


    it "returns in process if the state is in process" do
      @reserve.stub(:workflow_state).and_return('inprocess')
      expect(@course_row.workflow_state).to eq("In Process")
    end


    it "returns published if the state is in process" do
      @reserve.stub(:workflow_state).and_return('inprocess')
      expect(@course_row.workflow_state).to eq("In Process")
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


  describe :can_edit? do
    it "returns true if the user is an admin" do
      Permission.any_instance.stub(:current_user_is_administrator?).and_return(true)
      Permission.any_instance.stub(:current_user_is_admin_in_masquerade?).and_return(false)

      expect(@course_row.can_edit?).to be_true
    end

    it "returns true if the user is an admin in masq" do
      Permission.any_instance.stub(:current_user_is_administrator?).and_return(false)
      Permission.any_instance.stub(:current_user_is_admin_in_masquerade?).and_return(true)

      expect(@course_row.can_edit?).to be_true
    end

    it "returns false if the user is not an admin" do
      Permission.any_instance.stub(:current_user_is_administrator?).and_return(false)
      Permission.any_instance.stub(:current_user_is_admin_in_masquerade?).and_return(false)

      expect(@course_row.can_edit?).to be_false
    end
  end


  describe :edit_link do

    it "returns nothing if the row can be edited " do
      @course_row.stub(:can_edit?).and_return(false)
      expect(@course_row.edit_link).to eq("")
    end


    it "returns a link if the row can be edit " do
      @course_row.stub(:can_edit?).and_return(true)
      expect(@course_row.edit_link.match(/<a.*href="/)).to be_true
    end

  end


  describe :delete_sort do

    it "returns removed when a reserve is removed " do
      @reserve.stub(:removed?).and_return(true)
      expect(@course_row.delete_sort).to eq('removed')
    end


    it "returns available if the reserve is not removed" do
      @reserve.stub(:removed?).and_return(false)
      expect(@course_row.delete_sort).to eq('available')
    end
  end


end
