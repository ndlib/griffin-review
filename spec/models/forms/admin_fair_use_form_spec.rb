require 'spec_helper'


describe AdminFairUseForm do

  let (:user) { double(User, id: 1)}

  before(:each) {
    FactoryGirl.create(:semester)

    @c =  double(Course, id: 1, crosslist_id: 'crosslist_id', semester: Semester.first)

    CourseSearch.any_instance.stub(:get).and_return(@c)

    @item = FactoryGirl.create(:item)
    @reserve = mock_reserve FactoryGirl.create(:request, item: @item), @c

    ReserveSearch.any_instance.stub(:get).and_return(@reserve)
  }

  describe :checklist_questions do
    it "lists all the questions available for the form" do
      FairUseQuestion.stub(:active).and_return([double(FairUseQuestion, category: 'cat', subcategory: true), double(FairUseQuestion, category: 'cat', subcategory: false)])

      AdminFairUseForm.new(user, { id:  @reserve.id} ).checklist_questions['cat'][:notfavoring].size.should == 2
      AdminFairUseForm.new(user, { id:  @reserve.id} ).checklist_questions['cat'][:favoring].size.should == 0
    end
  end


  describe :question_checked? do

    it "returns true if the original fair use was checked" do
      fair_use = FairUse.new(checklist: { '1' => 'true', '2' => 'false'} )
      @reserve.stub(:fair_use).and_return(fair_use)

      afuf = AdminFairUseForm.new(user, { id:  @reserve.id} )

      afuf.question_checked?(double(FairUseQuestion, id: 1)).should be_truthy
    end


    it "returns true if the fair use was checked in the form params" do
      afuf = AdminFairUseForm.new(user, { id:  @reserve.id, admin_fair_use_form: { checklist: { '1' => "true" } } }  )

      afuf.question_checked?(double(FairUseQuestion, id: 1)).should be_truthy
    end


    it "returns false if the original fair use was unchecked" do
      fair_use = FairUse.new(checklist: { '1' => 'true', '2' => 'false'} )
      @reserve.stub(:fair_use).and_return(fair_use)

      afuf = AdminFairUseForm.new(user, { id:  @reserve.id} )

      afuf.question_checked?(double(FairUseQuestion, id: 2)).should be_falsey
    end


    it "returns false if the question value is not set" do
      afuf = AdminFairUseForm.new(user, { id:  @reserve.id} )
      afuf.question_checked?(double(FairUseQuestion, id: 2, category: 'Trending Toward Fair Use')).should be_falsey
    end

  end


  describe :previous_fair_uses do

    it "gets all the previous_comments" do
      @reserve2 = mock_reserve FactoryGirl.create(:request, item: @item), @c

      fu1 = FairUse.new(request_id: (@reserve2.id), item_id: @reserve.item.id, user_id: 2, created_at: 1.day.ago)
      fu1.save!

      fu2 = FairUse.new(request_id: @reserve.id, item_id: @reserve.item.id, user_id: 2)
      fu2.save!


      afuf = AdminFairUseForm.new(user, { id:  @reserve.id})
      afuf.previous_fair_uses.collect{ | a | a.id }.should == [fu1.id]
    end

    it "does not include the current fair use" do
      fu2 = FairUse.new(request_id: @reserve.id, item_id: @reserve.item.id, user_id: 2)
      fu2.save!

      afuf = AdminFairUseForm.new(user, { id:  @reserve.id} )
      afuf.previous_fair_uses.should == []
    end


    it "orders them chronologically" do
      @reserve2 = mock_reserve FactoryGirl.create(:request, item: @item), @c
      @reserve3 = mock_reserve FactoryGirl.create(:request, item: @item), @c

      fu1 = FairUse.new(request_id: (@reserve2.id), item_id: @reserve.item.id, user_id: 2, created_at: 2.days.ago)
      fu1.save!

      fu2 = FairUse.new(request_id: (@reserve3.id), item_id: @reserve.item.id, user_id: 2, created_at: 1.days.ago)
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
      afuf.save_fair_use.should be_truthy
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


    it "undeletes a removed item when it is changed to a undeleted state" do
      @reserve.remove
      @reserve.save!

      afuf = AdminFairUseForm.new(user, { id:  @reserve.id, admin_fair_use_form: { checklist: { '1' => "true" }, comments: "comments" } } )
      afuf.save_fair_use

      expect(@reserve.workflow_state).to eq("inprocess")
    end


    it "removes the reserve if the fair use is denied " do
      expect(@reserve).to receive(:save!)
      afuf = AdminFairUseForm.new(user, { id:  @reserve.id, admin_fair_use_form: { event: 'deny'} } )

      afuf.save_fair_use
      afuf.fair_use.state.should == "denied"
      afuf.fair_use.reserve.workflow_state.should == "removed"
    end


    it "checks if the reserve is complete" do
      ReserveCheckIsComplete.any_instance.should_receive(:check!)
      afuf = AdminFairUseForm.new(user, { id:  @reserve.id, admin_fair_use_form: { event: 'deny'} } )

      afuf.save_fair_use
    end


  end

end
