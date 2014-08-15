require 'spec_helper'

describe ThreadedCollection do
  let(:collection) { (1..20).to_a }
  subject { described_class.new(collection) }

  describe '#each' do
    it 'iterates over each element' do
      new_array = []
      subject.each do |item|
        expect(collection).to include(item)
        new_array << item
      end
      expect(new_array.count).to eq(collection.count)
    end

    it 'is threaded' do
      threaded_collection = described_class.new((1..10).to_a, 10)
      start = Time.new
      threaded_collection.each do |item|
        sleep(item / 100.0)
      end
      duration = Time.now - start
      expect(duration).to be < 0.11
      expect(duration).to be >= 0.1
    end
  end

  describe '#collect' do
    it 'returns items in order' do
      new_values = collection.collect{|item| item + 100}
      new_threaded_values = subject.collect{|item| item + 100}
      expect(new_threaded_values).to eq(new_values)
    end
  end
end
