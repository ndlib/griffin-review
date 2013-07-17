require 'spec_helper'

describe FairUseQuestion do

  describe :active do


    it "has an active attribute " do
      FairUseQuestion.new.respond_to?(:active)
    end


    it "can return only active questions" do
      FairUseQuestion.add_new_question!('something', 'category', 1, true)
      FairUseQuestion.add_new_question!('something', 'category', 2, false)

      questions = FairUseQuestion.active

      questions.size.should == 1
      questions.first.question.should == "something"
    end

  end


  describe :reorder do

    it "reorders the current question" do
      fuq = FairUseQuestion.add_new_question!('something', 'category', 1, true)

      fuq.reorder!(2)
      fuq.ord.should == 2
    end


    it "pushes back order questions ordered after the question" do
      fuq = FairUseQuestion.add_new_question!('something1', 'category', 1, true)
      FairUseQuestion.add_new_question!('something2', 'category', 2, true)
      FairUseQuestion.add_new_question!('something3', 'category', 3, true)

      fuq.reorder!(2)

      questions = FairUseQuestion.default_order.further_questions(3)
      questions.first.ord.should == 3
      questions.last.ord.should == 4
    end

  end


  describe :add_new_question! do

    it "adds a new question with valid params" do
      fuq = FairUseQuestion.add_new_question!('something1', 'category', 1, true)
      fuq.new_record?.should be_false
    end


    it "will move existing question back in the order" do
      fuq = FairUseQuestion.add_new_question!('something1', 'category', 1, true)
      FairUseQuestion.add_new_question!('something2', 'category', 1, true)

      fuq.reload
      fuq.ord.should == 2
    end

  end

  describe :validations do

    it "requires the question" do
      FairUseQuestion.new.should have(1).error_on(:question)
    end

    it "requires the ord" do
      FairUseQuestion.new.should have(1).error_on(:ord)
    end

    it "requires the category" do
      FairUseQuestion.new.should have(1).error_on(:category)
    end
  end
end
