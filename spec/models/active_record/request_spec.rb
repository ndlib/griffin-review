require 'spec_helper'

describe Request do
  subject { described_class.new }

  describe 'valid subject' do
    let(:valid_params) { {:course_id => 'course id', :requestor_netid => 'requestornetid', :item => Item.new, :semester => FactoryGirl.create(:semester)} }
    subject { described_class.new(valid_params) }
    it "passes validation" do
      expect(subject).to be_valid
    end

    it "calls #set_sortable_title on save" do
      expect(subject).to receive(:set_sortable_title)
      subject.save
    end
  end


  it "requires an item" do
    expect(subject).to have(1).error_on(:item)
  end


  it "requres a course id" do
    expect(subject).to have(1).error_on(:course_id)
  end


  it "requires the requestor_netid" do
    expect(subject).to have(1).error_on(:requestor_netid)
  end


  it "requires the semester is set" do
    expect(subject).to have(1).error_on(:semester)
  end

  describe '#primary_title' do
    it 'uses the selection title when it is present' do
      subject.item_title = 'title'
      subject.item_selection_title = 'selection_title'
      expect(subject.primary_title).to eq('selection_title')
    end

    it 'uses the item title when there is not a selection_title' do
      subject.item_title = 'title'
      subject.item_selection_title = nil
      expect(subject.primary_title).to eq('title')
    end
  end

  describe '#set_sortable_title' do
    it 'converts the primary_title' do
      expect(SortableTitleConverter).to receive(:convert).with('primary_title').and_return('converted_title')
      subject.stub(:primary_title).and_return('primary_title')
      subject.send(:set_sortable_title)
      expect(subject.sortable_title).to eq('converted_title')
    end
  end
end
