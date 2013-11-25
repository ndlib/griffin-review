require 'spec_helper'


describe RequestDetail do
  # setup
  before(:each) do
    @controller = double(ApplicationController, params: { id: 1 })
    @reserve = double(Reserve, id: 1, start: false, save!: true, workflow_state: 'inprocess')
    RequestDetail.any_instance.stub(:reserve_search).and_return(@reserve)

    @request_detail = RequestDetail.new(@controller)
  end


  describe :ensures_reserve_is_inproces do
    it "changes new to inprocess" do
      @reserve = double(Reserve, id: 1, start: true, save!: true, workflow_state: 'new')

      expect(RequestDetail.new(@controller).reserve.workflow_state).to eq("inprocess")
    end

    it "calls check in process" do
      ReserveCheckInprogress.any_instance.should_receive(:check!)
      RequestDetail.new(@controller)
    end
  end


  describe :special_instructions do

    context "empty" do

      it "returns none if the instructions are nil" do
        @reserve.stub(:note).and_return(nil)
        expect(@request_detail.special_instructions).to eq("<p></p>")
      end


      it "returns none if the instructions are nil" do
        @reserve.stub(:note).and_return("")
        expect(@request_detail.special_instructions).to eq("<p></p>")
      end
    end


    context "has data" do

      it "returns the notes with html" do
        @reserve.stub(:note).and_return("notes")
        expect(@request_detail.special_instructions).to eq("<p>notes</p>")
      end


      it "formats the html with simple format" do
        @reserve.stub(:note).and_return("notes")
        @request_detail.send(:helpers).should_receive(:simple_format)

        @request_detail.special_instructions
      end
    end
  end


  describe :citation do

    it "formats the html with simple format" do
      @reserve.stub(:citation).and_return("citation")
      @request_detail.send(:helpers).should_receive(:simple_format)

      @request_detail.citation
    end


    it "converst links to a tags " do
      @reserve.stub(:citation).and_return("http://www.google.com")
      expect(@request_detail.citation).to eq("<p><a href=\"http://www.google.com\">http://www.google.com</a></p>")
    end

    it "truncates a long url" do
      @reserve.stub(:citation).and_return("http://www.google.com?dfsasdfasfasdfadsfadsfadsfasdfafasdfdajsfkljasdflkjasklfjalskdfjklasdjfklasdjflasdfjasdfjasdfas")
      expect(@request_detail.citation).to eq("<p><a href=\"http://www.google.com?dfsasdfasfasdfadsfadsfadsfasdfafasdfdajsfkljasdflkjasklfjalskdfjklasdjfklasdjflasdfjasdfjasdfas\">http://www.google.com?dfsasdfasfasdfadsfadsfadsfasdfafasdfdajsfkljasdflkjasklfjalskdfjklasdjfklas...</a></p>")
    end
  end
end
