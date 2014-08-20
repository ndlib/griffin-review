require 'spec_helper'

describe RequestRowListGroup do
  def request_row(id)
    double(RequestRow, id: id, cache_key: "cache-#{id}")
  end

  def request_rows(count)
    (1..count).collect{|id| request_row(id)}
  end

  let(:rows) { request_rows(5)}

  subject{ described_class.new(rows) }

  describe '#cache_key' do
    it 'changes when the cache key of a row changes' do
      original_cache_key = subject.cache_key
      new_row_cache_key = rows.first.cache_key + 'new'
      rows.first.stub(:cache_key).and_return(new_row_cache_key)
      expect(subject.cache_key).to_not eq(original_cache_key)
    end
  end

  describe '#to_json' do
    it 'combines the json of each row' do
      rows.each do |row|
        row.stub(:cached_json).and_return({id: row.id}.to_json)
      end
      expect(subject.to_json).to eq("{\"id\":1},{\"id\":2},{\"id\":3},{\"id\":4},{\"id\":5}")
    end
  end
end
