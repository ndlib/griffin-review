class SortableTitleConverter
  attr_reader :original_title

  def self.convert(title)
    new(title).converted_title
  end

  def initialize(original_title)
    @original_title = original_title
  end

  def converted_title
    if @converted_title.nil?
      @converted_title = original_title.to_s.strip.downcase
      @converted_title.gsub!(/['"`“‘]+/, '')
      @converted_title.sub!(/^(the|a|an)\s+/i, '')
      @converted_title.strip!
    end
    @converted_title
  end
end
