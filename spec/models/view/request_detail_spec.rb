require 'spec_helper'


describe RequestDetail do
  # setup
  before(:each) do
    @controller = double(ApplicationController, params: { id: 1 })
    @course = double(Course, id: 'id')
    @reserve = double(Reserve, id: 1, start: false, save!: true, workflow_state: 'inprocess', course: @course, library: 'hesburgh')
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

  describe '#library' do

    it "translates the library code into the proper library name" do
      expect(@request_detail.library).to eq 'Hesburgh Library'
    end

  end


  describe :delete_link do

    it "returns a link to delete the reserve from the course and return to this page " do
      expect(@request_detail.delete_link).to eq("<a class=\"btn btn-danger\" data-confirm=\"Are you sure you wish to remove this reserve from this semester?\" data-method=\"delete\" href=\"/courses/id/reserves/1?redirect_to=admin\" id=\"delete_reserve_1\" rel=\"nofollow\"><i class=\"icon-remove\"></i> Delete Reserve</a>")
    end
  end
end
