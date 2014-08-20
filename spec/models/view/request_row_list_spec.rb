require 'spec_helper'

describe RequestRowList do
  def request_row(id)
    double(RequestRow, id: id, cache_key: "cache-#{id}")
  end

  def request_rows(count)
    (1..count).collect{|id| request_row(id)}
  end
  let(:request_list) { double(ListRequests) }
  subject{ described_class.new(request_list) }

  describe '#request_list' do
    it 'is the request_list' do
      expect(subject.request_list).to eq(request_list)
    end
  end

  describe '#reserves' do
    it 'is the request_list reserves' do
      expect(request_list).to receive(:reserves).and_return(['reserves'])
      expect(subject.reserves).to eq(['reserves'])
    end
  end

  describe '#rows' do
    it 'creates a request row for each reserve' do
      expect(subject).to receive(:reserves).and_return(['reserve1', 'reserve2'])
      expect(subject).to receive(:build_row).with('reserve1').and_return('row1')
      expect(subject).to receive(:build_row).with('reserve2').and_return('row2')
      expect(subject.rows).to eq(['row1','row2'])
    end
  end

  describe '#build_row' do
    it 'builds a RequestRow' do
      expect(RequestRow).to receive(:new).with('reserve').and_return('row')
      expect(subject.send(:build_row, 'reserve')).to eq('row')
    end
  end

  describe '#groups' do
    let(:rows) { [request_row(1), request_row(99), request_row(201), request_row(301)]}
    it 'groups the rows by the id in groups of 100' do
      subject.stub(:rows).and_return(rows)
      expect(RequestRowListGroup).to receive(:new).with(rows[0,2]).and_return('group1')
      expect(RequestRowListGroup).to receive(:new).with(rows[2,1]).and_return('group2')
      expect(RequestRowListGroup).to receive(:new).with(rows[3,1]).and_return('group3')
      expect(subject.groups).to eq(['group1','group2','group3'])
    end
  end

  describe '#to_json' do
    let(:groups) { [double(RequestRowListGroup), double(RequestRowListGroup)]}
    it 'combines the group to_json' do
      groups.each_with_index do |group, index|
        group.stub(:to_json).and_return({group: index}.to_json)
      end
      subject.stub(:groups).and_return(groups)
      expect(subject.to_json).to eq("{\"group\":0},{\"group\":1}")
    end
  end
end
