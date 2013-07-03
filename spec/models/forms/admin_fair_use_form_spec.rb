require 'spec_helper'


describe AdminFairUseForm do

  let (:user) { mock(User, id: 1)}

  before(:each) {
    @reserve = mock_reserve FactoryGirl.create(:request), mock(Course, id: 1, crosslist_id: 'crosslist_id', semester: Semester.first)
    ReserveSearch.any_instance.stub(:get).and_return(@reserve)
  }

  describe :checklist_questions do
    it "lists all the questions available for the form" do
      FairUseQuestion.stub(:active).and_return([mock(FairUse), mock(FairUse)])

      AdminFairUseForm.new(user, { id:  @reserve.id} ).checklist_questions.size.should == 2
    end
  end


  describe :question_checked? do

    it "returns true if the original fair use was checked" do
      fair_use = FairUse.new(checklist: { '1' => 'true', '2' => 'false'} )
      @reserve.stub(:fair_use).and_return(fair_use)

      afuf = AdminFairUseForm.new(user, { id:  @reserve.id} )

      afuf.question_checked?(mock(FairUseQuestion, id: 1)).should be_true
    end


    it "returns true if the fair use was checked in the form params" do
      afuf = AdminFairUseForm.new(user, { id:  @reserve.id, admin_fair_use_form: { checklist: { '1' => "true" } } }  )

      afuf.question_checked?(mock(FairUseQuestion, id: 1)).should be_true
    end


    it "returns false if the original fair use was unchecked" do
      fair_use = FairUse.new(checklist: { '1' => 'true', '2' => 'false'} )
      @reserve.stub(:fair_use).and_return(fair_use)

      afuf = AdminFairUseForm.new(user, { id:  @reserve.id} )

      afuf.question_checked?(mock(FairUseQuestion, id: 2)).should be_false
    end


    it "returns false if the question value is not set" do
      afuf = AdminFairUseForm.new(user, { id:  @reserve.id} )
      afuf.question_checked?(mock(FairUseQuestion, id: 2)).should be_false
    end

  end


  describe :previous_fair_uses do

    it "gets all the previous_comments" do
      fu1 = FairUse.new(request_id: (@reserve.id + 1), item_id: @reserve.item.id, user_id: 2, created_at: 1.day.ago)
      fu1.save!

      fu2 = FairUse.new(request_id: @reserve.id, item_id: @reserve.item.id, user_id: 2)
      fu2.save!


      afuf = AdminFairUseForm.new(user, { id:  @reserve.id} )
      afuf.previous_fair_uses.collect{ | a | a.id }.should == [fu1.id]
    end

    it "does not include the current fair use" do
      fu2 = FairUse.new(request_id: @reserve.id, item_id: @reserve.item.id, user_id: 2)
      fu2.save!


      afuf = AdminFairUseForm.new(user, { id:  @reserve.id} )
      afuf.previous_fair_uses.should == []
    end


    it "orders them chronologically" do
      fu1 = FairUse.new(request_id: (@reserve.id + 1), item_id: @reserve.item.id, user_id: 2, created_at: 2.days.ago)
      fu1.save!

      fu2 = FairUse.new(request_id: (@reserve.id + 2), item_id: @reserve.item.id, user_id: 2, created_at: 1.days.ago)
      fu2.save!
      fu3 = FairUse.new(request_id: @reserve.id, item_id: @reserve.item.id, user_id: 2)
      fu3.save!


      afuf = AdminFairUseForm.new(user, { id:  @reserve.id} )
      afuf.previous_fair_uses.collect{ | a | a.id }.should == [fu1.id, fu2.id]
    end

  end


  describe :persistance do

    it "saves its self with valid params" do
      afuf = AdminFairUseForm.new(user, { id:  @reserve.id, admin_fair_use_form: { checklist: { '1' => "true" }, comments: "comments" } } )
      afuf.save_fair_use.should be_true
    end


    it "saves the current user as the person who last edited the form" do
      afuf = AdminFairUseForm.new(user, { id:  @reserve.id } )
      afuf.save_fair_use
      afuf.fair_use.user_id.should == user.id
    end


    it "can run an event passed in " do
      afuf = AdminFairUseForm.new(user, { id:  @reserve.id, admin_fair_use_form: { event: 'approve'} } )
      afuf.save_fair_use
      afuf.fair_use.state.should == "approved"
    end


    it "saves comments " do
      afuf = AdminFairUseForm.new(user, { id:  @reserve.id, admin_fair_use_form: { checklist: { '1' => "true" }, comments: "comments" } } )
      afuf.save_fair_use

      afuf.fair_use.comments.should == "comments"
    end


    it "saves checklists " do
      afuf = AdminFairUseForm.new(user, { id:  @reserve.id, admin_fair_use_form: { checklist: { '1' => "true" }, comments: "comments" } } )
      afuf.save_fair_use

      afuf.fair_use.checklist['1'].should == "true"
    end


    it "checks to seed if the item is complete" do
      ReserveCheckIsComplete.any_instance.should_receive(:check!)

      afuf = AdminFairUseForm.new(user, { id:  @reserve.id, admin_fair_use_form: { checklist: { '1' => "true" }, comments: "comments" } } )
      afuf.save_fair_use
    end

  end

end
