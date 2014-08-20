require 'spec_helper'

describe RequestRowList do
  def request_row(id)
    double(RequestRow, id: id, cache_key: "cache-#{id}")
  end

  def request_rows(count)
    (1..count).collect{|id| request_row(id)}
  end

  let(:rows) { request_rows(5)}
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
end
