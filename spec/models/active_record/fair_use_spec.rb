require 'spec_helper'


describe FairUse do

  describe :validations  do

    it "requires the user_id" do
      FairUse.new.should have(1).error_on(:user_id)
    end

  end


  describe :checklist do

    it "allows you to set a checklist" do
      f = FairUse.new(:user => mock_model(User, id: 1), request: mock_model(Request, id: 1), state: "update")
      f.checklist = { '1' => true, '2' => false}
      f.save!
      f.checklist.class.should == ActiveSupport::HashWithIndifferentAccess
    end

  end


  describe :copy_to_new_request! do

    it "resets the comments " do
      f = FairUse.new(:user => mock_model(User, id: 1), request: mock_model(Request, id: 1), comments: "comments", state: "approved")
      nf = f.copy_to_new_request!(mock_model(Request, id: 2), mock_model(User, id: 2))

      nf.comments.should == ""
    end


    it "resets the state to update " do
      f = FairUse.new(:user => mock_model(User, id: 1), request: mock_model(Request, id: 1), comments: "comments", state: "approved")
      nf = f.copy_to_new_request!(mock_model(Request, id: 2), mock_model(User, id: 2))

      nf.state.should == "update"
    end


    it "changes the request to the new one" do
      f = FairUse.new(:user => mock_model(User, id: 1), request: mock_model(Request, id: 1), comments: "comments", state: "approved")
      nf = f.copy_to_new_request!(mock_model(Request, id: 2), mock_model(User, id: 2))

      nf.request.id.should == 2
    end

    it "changes the user to one passed in " do
      f = FairUse.new(:user => mock_model(User, id: 1), request: mock_model(Request, id: 1), comments: "comments", state: "approved")
      nf = f.copy_to_new_request!(mock_model(Request, id: 2), mock_model(User, id: 2))

      nf.user.id.should == 2
    end

    it "saves the new request" do
      f = FairUse.new(:user => mock_model(User, id: 1), request: mock_model(Request, id: 1), comments: "comments", state: "approved")
      nf = f.copy_to_new_request!(mock_model(Request, id: 2), mock_model(User, id: 2))

      nf.new_record?.should be_false
    end
  end


  describe :state do

    it "starts in the update state" do
      FairUse.new.state.should == "update"
    end


    it "can transition to approved from update " do
      f = FairUse.new(:user_id => 1)
      f.approve

      f.state.should == "approved"
    end


    it "can transition to denied from update " do
      f = FairUse.new(:user_id => 1)
      f.deny

      f.state.should == "denied"
    end


    it "can transition to temporary_approval from update" do
      f = FairUse.new(:user_id => 1)
      f.temporary_approval

      f.state.should == "temporary_approval"
    end


    it "can transition to denied from approved " do
      f = FairUse.new(:user_id => 1, :state => 'approved')
      f.deny

      f.state.should == "denied"
    end


    it "can transition to denied from temporary_approval " do
      f = FairUse.new(:user_id => 1, :state => 'temporary_approval')
      f.deny

      f.state.should == "denied"
    end

  end


  describe :by_item do

    it "can return all the fair uses for a specific item" do
      r1 = mock_reserve FactoryGirl.create(:request), nil
      r2 = mock_reserve FactoryGirl.create(:request), nil

      FairUse.create!(user_id: 1, item_id: r1.item_id)
      FairUse.create!(user_id: 1, item_id: r1.item_id)
      FairUse.create!(user_id: 1, item_id: r2.item_id)

      FairUse.by_item(r1.item).size.should == 2
    end
  end


  describe :complete? do

    it "is comeplete if the state is approved" do
      FairUse.new(user_id: 1, state: "approved").complete?.should be_true
    end


    it "is complete if the state is denied" do
      FairUse.new(user_id: 1, state: "denied").complete?.should be_true
    end


    it "is complete if the state is temporary_approval" do
      FairUse.new(user_id: 1, state: "temporary_approval").complete?.should be_true
    end


    it "is not complete if the state is update" do
      FairUse.new(user_id: 1, state: "update").complete?.should be_false
    end

  end

  describe :versioning do

    it "has some versioning system" do
      FairUse.create!(user_id: 1).respond_to?(:versions)
    end
  end

end
