class Item < ActiveRecord::Base

  has_many :requests

  validates :title, :type, presence: true

  self.inheritance_column = nil

  has_attached_file :pdf


  def title
    use_discovery_api? ? discovery_record.title : self[:title]
  end

  def creator_contributor
    use_discovery_api? ? discovery_record.creator_contributor : self.creator
  end


  def publisher_provider
    use_discovery_api? ? discovery_record.publisher_provider : self.journal_title
  end


  def details
    use_discovery_api? ? discovery_record.details : ""
  end


  def availability
    use_discovery_api? ? discovery_record.availability : ""
  end


  def available_library
    use_discovery_api? ? discovery_record.available_library : ""
  end


  def is_available?
    (self.availability.strip == 'Available')
  end


  private

    def use_discovery_api?
      nd_meta_data_id.present? && !overwrite_nd_meta_data?
    end


    def discovery_record
      if use_discovery_api?
        @discovery_record ||= DiscoveryApi.search_by_ids(nd_meta_data_id).first
      end
    end

end
