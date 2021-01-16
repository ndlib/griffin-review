class WorldCatOCLC
  EXCLUDED_DESCRIPTION_FIELDS = [506, 530, 540, 546]

  FIELD_MAP = {
    :creator => { :fields => [100, 110, 111, 700, 710, 711, 720], :subfields => ['a'] },
    :subject => { :fields => [600, 610, 611, 630, 650, 653] },
    :description => { :fields => (500..599).reject{|i| EXCLUDED_DESCRIPTION_FIELDS.include?(i)} },
    :coverage => { :fields => [651, 752] },
    :rights => { :fields => [506, 540] },
    :relation => { :fields => [760..787], :subfields => ['o','t'] }
  }

  attr_accessor :title, :author, :isbn, :creator, :subject, :description, :publisher, :date, :type, :format, :identifier, :source, :language, :relation, :coverage, :rights


  def initialize(values)
    if values[:oclc].present?
      if is_number?(values[:oclc]) # server side check that oclc is numeric only!
        @reserve = self.class.client.single_record(:oclc => values[:oclc].to_s.strip)
      else
        raise WorldCat::WorldCatError.new, "Record does not exist"
      end
    elsif values[:isbn].present?
      @reserve = self.class.client.single_record(:isbn => values[:isbn].to_s.strip)
    else
      raise WorldCat::WorldCatError.new, "Record does not exist"
    end
    map_dublin_core()
  end

  def self.client
    api_key = Rails.application.secrets.worldcat["api"]
    @client ||= WorldCat.new(api_key)
  end

  def self.test
    self.new(43628981)
  end

  def reserve
    @reserve
  end

  private
    def map_dublin_core
      title_value = marc_value('245','a','b')
      if title_value.is_a?(Array)
        title_value = title_value.join(' ').strip
      end
      self.title = title_value.to_s.strip.gsub(/ \/$/,'')

      FIELD_MAP.each do |key, options|
        if self.send(key).blank?
          self.send("#{key}=", [])
        end
        options[:fields].each do |field|
          value = marc_value(field, *options[:subfields])
          if value.present?
            self.send(key).push(value)
          end
        end
        self.send(key).flatten!
        self.send(key).compact!
      end

      statement = marc_value('245','c')
      if statement.present?
        self.author = [statement]
      else
        self.author = self.creator
      end

      if field_exists?('260')
        publisher_field = '260'
      else
        publisher_field = '264'
      end
      self.publisher = marc_value(publisher_field,'a','b')
      if self.publisher.is_a?(Array)
        self.publisher = self.publisher.join(' ')
      end
      self.date = marc_value(publisher_field,'c')
      self.type = marc_value('655')
      self.format = marc_value('856','q')
      self.identifier = marc_value('856','u')
      self.source = marc_value('786','o','t')
      self.language = marc_value('546')

      self.relation = []
      if value = marc_value('530')
        self.relation << value
      end
      true
    end

    def field_exists?(field)
      reserve[field.to_s].present?
    end

    def marc_value(field, *subfields)
      datafield = reserve[field.to_s]
      return if datafield.nil?
      subfields.compact!
      if subfields.blank?
        values = datafield.subfields.collect{|s| s.value}
        if values.size == 1
          values.first
        else
          values
        end
      else
        values = []
        subfields.each do |subfield|
          values << datafield[subfield]
        end
        if subfields.size == 1
          values.first
        else
          values
        end
      end
    end

    def is_number? string
      true if Float(string) rescue false
    end
end
