require 'spec_helper'


describe FairUse do
  describe :validations  do
    it "requires the user_id" do
      FairUse.new.should have(1).error_on(:user_id)
    end
  end

  describe :checklist do

    it "allows you to set a checklist" do
      f = FairUse.new(:user => User.new(id: 1), request: Request.new(id: 1), state: "update")
      f.checklist = { '1' => true, '2' => false}
      f.save!
      f.checklist.class.should == ActiveSupport::HashWithIndifferentAccess
    end

  end


  describe :copy_to_new_request! do

    it "resets the comments " do
      f = FairUse.new(:user => User.new(id: 1), request: Request.new(id: 1), comments: "comments", state: "approved")
      nf = f.copy_to_new_request!(Request.new(id: 2), User.new(id: 2))

      nf.comments.should == ""
    end


    it "resets the state to update " do
      f = FairUse.new(:user => User.new(id: 1), request: Request.new(id: 1), comments: "comments", state: "approved")
      nf = f.copy_to_new_request!(Request.new(id: 2), User.new(id: 2))

      nf.state.should == "update"
    end


    it "changes the request to the new one" do
      f = FairUse.new(:user => User.new(id: 1), request: Request.new(id: 1), comments: "comments", state: "approved")
      nf = f.copy_to_new_request!(Request.new(id: 2), User.new(id: 2))

      nf.request.id.should == 2
    end

    it "changes the user to one passed in " do
      f = FairUse.new(:user => User.new(id: 1), request: Request.new(id: 1), comments: "comments", state: "approved")
      nf = f.copy_to_new_request!(Request.new(id: 2), User.new(id: 2))

      nf.user.id.should == 2
    end

    it "saves the new request" do
      f = FairUse.new(:user => User.new(id: 1), request: Request.new(id: 1), comments: "comments", state: "approved")
      nf = f.copy_to_new_request!(Request.new(id: 2), User.new(id: 2))

      nf.new_record?.should be_falsey
    end
  end


  describe :state do

    [:update, :temporary_approval, :approved, :copy_rights_cleared, :sipx_cleared, :denied].each do | state|
      { approve: :approved, clear_with_sipx: :sipx_cleared, clear_with_copy_rights: :copy_rights_cleared, deny: :denied, temporary_approval: :temporary_approval }.each do | event, final_state |

        it "should change from state #{state} to #{final_state} using #{event}" do
          f = FairUse.new(:user_id => 1, :state => state)
          f.send(event)

          expect(f.state.to_s).to eq(final_state.to_s)
        end

      end
    end

  end


  describe :by_item do

    it "can return all the fair uses for a specific item" do
      r1 = mock_reserve FactoryBot.create(:request), nil
      r2 = mock_reserve FactoryBot.create(:request), nil

      FairUse.create!(user_id: 1, item_id: r1.item_id)
      FairUse.create!(user_id: 1, item_id: r1.item_id)
      FairUse.create!(user_id: 1, item_id: r2.item_id)

      FairUse.by_item(r1.item).size.should == 2
    end
  end


  describe :complete? do

    it "is comeplete if the state is approved" do
      FairUse.new(user_id: 1, state: "approved").complete?.should be_truthy
    end


    it "is complete if the state is denied" do
      FairUse.new(user_id: 1, state: "denied").complete?.should be_truthy
    end


    it "is complete if the state is temporary_approval" do
      FairUse.new(user_id: 1, state: "temporary_approval").complete?.should be_truthy
    end


    it "is complete if the state is sipx_cleared" do
      FairUse.new(user_id: 1, state: "sipx_cleared").complete?.should be_truthy
    end


    it "is complete if the state is copy_rights_cleared" do
      FairUse.new(user_id: 1, state: "copy_rights_cleared").complete?.should be_truthy
    end

    it "is not complete if the state is update" do
      FairUse.new(user_id: 1, state: "update").complete?.should be_falsey
    end


  end

  describe :versioning do

    it "has some versioning system" do
      FairUse.create!(user_id: 1).respond_to?(:versions)
    end
  end

end
