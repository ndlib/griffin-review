class ThreadedCollection
  attr_reader :collection, :thread_count

  def initialize(collection, thread_count = 4)
    @collection = collection
    @thread_count = thread_count
  end

  def collect
    new_collection = [nil]*collection.count
    each_with_index do |item, index|
      new_value = yield item
      new_collection[index] = new_value
    end
    new_collection
  end

  def each_with_index
    queue = Queue.new
    collection.each_with_index {|item, index| queue << [item, index]}
    process_threaded do
      while (item_array = queue.pop(true) rescue nil)
        if item_array.present?
          item = item_array[0]
          index = item_array[1]
          yield item, index
        end
      end
    end
    self
  end

  def each
    each_with_index do |item, index|
      yield item
    end
    self
  end

  private

  def process_threaded()
      threads = []
      thread_count.times do
        threads << Thread.new do
          yield
        end
      end
      wait_for_threads_to_complete(threads)
    end

  def wait_for_threads_to_complete(threads)
    # Thread#join will not return until the thread is done executing its block
    threads.each {|t| t.join }
  end
end
