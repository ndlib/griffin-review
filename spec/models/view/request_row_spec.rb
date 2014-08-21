require 'spec_helper'

describe RequestRow do
  let(:reserve) { Reserve.factory(request) }
  let(:request) { Request.new(item: item, id: 1) }
  let(:item) { Item.new }
  subject { described_class.new(reserve) }

  it "has a title" do
    expect(subject.respond_to?(:title)).to be_true
  end

  it "links to the request item_title" do
    request.item_title = 'title'
    expect(subject.title).to eq("<a href=\"/admin/requests/1\" target=\"_blank\">title</a>")
  end


  it "shows the selection title when there is a selection title" do
    request.item_title = 'title'
    request.item_selection_title = 'selection_title'
    expect(subject.title).to eq("<a href=\"/admin/requests/1\" target=\"_blank\">selection_title</a><br>title")
  end


  it "has an id" do
    expect(RequestRow.new(Reserve.new).respond_to?(:id)).to be_true
  end

  it "has the date needed" do
    expect(RequestRow.new(Reserve.new).respond_to?(:needed_by)).to be_true
  end


  it "catches if the needed_by date is nil" do |variable|
    expect(RequestRow.new(Reserve.new).needed_by).to eq("Not Entered")
  end


  it "needed_by_json catches if needed_by is nil" do
    expect(RequestRow.new(Reserve.new).needed_by_json).to eq(9999999999)
  end


  it "has a request date" do
    expect(request).to receive(:created_at).and_return(DateTime.parse('2014-08-10'))
    expect(subject.request_date).to eq('10 Aug')
  end

  describe '#request_date_timestamp' do
    it 'is the integer value of the request#created_at' do
      expect(request).to receive(:created_at).and_return(DateTime.parse('2014-08-10'))
      expect(subject.request_date_timestamp).to eq(1407628800)
    end
  end

  describe '#not_in_aleph?' do
    describe 'physical reserve not in aleph' do
      before do
        request.stub(:currently_in_aleph?).and_return(false)
        request.stub(:item_physical_reserve?).and_return(true)
        request.stub(:workflow_state).and_return('inprocess')
      end

      it 'is true' do
        expect(subject.not_in_aleph?).to be_true
      end

      it 'is false for removed' do
        request.stub(:workflow_state).and_return('removed')
        expect(subject.not_in_aleph?).to be_false
      end

      it 'is false if not a physical reserve' do
        request.stub(:item_physical_reserve?).and_return(false)
        expect(subject.not_in_aleph?).to be_false
      end

      it 'is false if currently in aleph' do
        request.stub(:currently_in_aleph?).and_return(true)
        expect(subject.not_in_aleph?).to be_false
      end
    end
  end

  describe '#request_statuses' do
    it 'can include on_order' do
      request.stub(:workflow_state).and_return('inprocess')
      request.stub(:item_on_order?).and_return(true)
      expect(subject.request_statuses).to eq('on_order')
    end

    it 'can include in_process' do
      request.stub(:workflow_state).and_return('inprocess')
      request.stub(:item_on_order?).and_return(false)
      expect(subject.request_statuses).to eq('inprocess')
    end

    it 'can include new' do
      request.stub(:workflow_state).and_return('new')
      expect(subject.request_statuses).to eq('new')
    end

    it 'can include available' do
      request.stub(:workflow_state).and_return('available')
      expect(subject.request_statuses).to eq('available')
    end

    it 'can include removed' do
      request.stub(:workflow_state).and_return('removed')
      expect(subject.request_statuses).to eq('removed')
    end

    it 'includes not_in_aleph if #not_in_aleph? is true' do
      request.stub(:workflow_state).and_return('inprocess')
      subject.stub(:not_in_aleph?).and_return(true)
      expect(subject.request_statuses).to eq('inprocess not_in_aleph')
    end

    it 'does not include not_in_aleph if #not_in_aleph? is false' do
      request.stub(:workflow_state).and_return('inprocess')
      subject.stub(:not_in_aleph?).and_return(false)
      expect(subject.request_statuses).to eq('inprocess')
    end
  end

  describe '#type' do
    it "exists" do
      expect(subject).to respond_to(:type)
    end

    it "pulls the type from the request#item_type" do
      request.item_type = "type"
      expect(subject.type).to eq("type")
    end

    it "works with nil" do
      request.item_type = nil
      expect(subject.type).to eq("")
    end
  end

  describe '#type_display' do
    it 'is the #type' do
      expect(subject).to receive(:type).and_return('original_type')
      expect(subject.type_display).to eq('original_type')
    end

    it "strips 'Reserve'" do
      subject.stub(:type).and_return("AudioReserve")
      expect(subject.type_display).to eq("Audio")
    end
  end

  describe '#search_keywords' do
    it 'is blank by default' do
      expect(subject.search_keywords).to eq('')
    end

    it 'is electronic' do
      request.item_electronic_reserve = true
      expect(subject.search_keywords).to eq('electronic')
    end

    it 'is physical' do
      request.item_physical_reserve = true
      expect(subject.search_keywords).to eq('physical')
    end

    it 'is both physical and electronic' do
      request.item_physical_reserve = true
      request.item_electronic_reserve = true
      expect(subject.search_keywords).to eq('electronic physical')
    end
  end


  it "has the workflow state" do
    expect(RequestRow.new(Reserve.new).respond_to?(:workflow_state)).to be_true
  end


  it "has a requestor column" do
    expect(RequestRow.new(Reserve.new).respond_to?(:requestor_col)).to be_true
  end


  it "has a instructor_col" do
    expect(RequestRow.new(Reserve.new).respond_to?(:instructor_col)).to be_true
  end

  it "has a column for course" do
    expect(RequestRow.new(Reserve.new).respond_to?(:course_col)).to be_true
  end

  it "#library exists" do
    request.stub(:library).and_return('hesburgh')
    expect(subject.library).to eq('hesburgh')
  end


  it "has a cache key" do
    expect(RequestRow.new(Reserve.new).respond_to?(:cache_key)).to be_true
  end


  it "makes the key out of the reserve" do
    reserve = mock_reserve FactoryGirl.create(:request), nil
    expect(RequestRow.new(reserve).cache_key).to eq("admin-reserve-#{reserve.id}-#{reserve.updated_at.to_i}")
  end


  it "makes an array for json rendering" do
    Reserve.any_instance.stub(:course).and_return(double(Course, id: 'course_id', semester: FactoryGirl.create(:semester), full_title: 'Course', primary_instructor: double(User, first_name: 'fname', last_name: 'lname', username: 'username')))
    r = Reserve.new(title: 'json', needed_by: '1/1/2013', requestor_netid: 'jhartzle', course_id: 'course_id', type: 'VideoReserve', physical_reserve: true, electronic_reserve: false, library: 'hesburgh')
    r.save!

    expect(RequestRow.new(r).to_json).to eq([" 1 Jan", "<a href=\"/admin/requests/2\" target=\"_blank\">json</a>", Time.now.to_date.to_s(:short), "<a href=\"/masquerades/new?username=username\">lname, fname</a>", "<a href=\"/courses/course_id/reserves\" target=\"_blank\">Course</a>", "Video", r.created_at.to_time.to_i, 1357016400, "physical", "new not_in_aleph", "hesburgh", "VideoReserve"])
  end


end
