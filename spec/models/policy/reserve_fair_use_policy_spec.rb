require 'spec_helper'

describe ReserveFairUsePolicy do


  describe "#complete?"  do

    it "returns false if the reserve needs fair use but has not set it yet" do
      reserve = mock_reserve FactoryBot.create(:request, :book_chapter), nil
      policy = ReserveFairUsePolicy.new(reserve)

      policy.stub(:requires_fair_use?).and_return(true)

      policy.complete?.should be_falsey
    end


    it "returns true if the reserve should not have fair use" do
      reserve = mock_reserve FactoryBot.create(:request, :book_chapter), nil
      policy = ReserveFairUsePolicy.new(reserve)

      policy.stub(:requires_fair_use?).and_return(false)

      policy.complete?.should be_truthy
    end


    it "returns true if the reserve needs fair use and it has been set." do
      reserve = mock_reserve FactoryBot.create(:request, :book_chapter), nil
      reserve.stub(:fair_use).and_return(double(FairUse, complete?: true))

      policy = ReserveFairUsePolicy.new(reserve)
      policy.stub(:requires_fair_use?).and_return(true)

      policy.complete?.should be_truthy
    end

  end



  describe "requires_fair_use?" do

    it "returns true is the type of the request is a book chapter" do
      reserve = mock_reserve FactoryBot.create(:request, :book_chapter), nil
      policy = ReserveFairUsePolicy.new(reserve)

      policy.requires_fair_use?.should be_truthy
    end


    it "returns false if the type of request is a book chapter and there is no file attached" do
      reserve = mock_reserve FactoryBot.create(:request, :book_chapter), nil
      reserve.pdf.destroy
      reserve.url = "http://www.google.com"

      policy = ReserveFairUsePolicy.new(reserve)

      policy.requires_fair_use?.should be_falsey
    end

    it "returns true is the type of the request is a journal with a file attached" do
      reserve = mock_reserve FactoryBot.create(:request, :journal_file), nil
      policy = ReserveFairUsePolicy.new(reserve)

      policy.requires_fair_use?.should be_truthy
    end


    it "returns true if the type is a video" do
      reserve = mock_reserve FactoryBot.create(:request, :video), nil
      policy = ReserveFairUsePolicy.new(reserve)

      policy.requires_fair_use?.should be_truthy
    end


    it "returns true if the tyoe is an audio" do
      reserve = mock_reserve FactoryBot.create(:request, :audio), nil
      policy = ReserveFairUsePolicy.new(reserve)

      policy.requires_fair_use?.should be_truthy
    end


    it "returns false if the type is a journal with a url" do
      reserve = mock_reserve FactoryBot.create(:request, :journal_url), nil
      policy = ReserveFairUsePolicy.new(reserve)

      policy.requires_fair_use?.should be_falsey
    end


    it "returns false if the type is a book" do
      reserve = mock_reserve FactoryBot.create(:request, :book), nil
      policy = ReserveFairUsePolicy.new(reserve)

      policy.requires_fair_use?.should be_falsey
    end

  end
end
