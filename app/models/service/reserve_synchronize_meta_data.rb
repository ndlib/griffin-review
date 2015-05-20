class ReserveSynchronizeMetaData
  attr_reader :reserve

  def initialize(reserve)
    @reserve = reserve
  end


  def synchronize!
    if can_be_synchronized?
      map_data!
    end
  end


  def valid_discovery_id?
    discovery_record.present?
  end


  private

    def can_be_synchronized?
      @reserve.nd_meta_data_id.present?
    end


    def map_data!
      return if !valid_discovery_id?

      if discovery_record.type == 'journal'
        @reserve.journal_title = discovery_record.title
      else
        @reserve.title =  discovery_record.title
        @reserve.journal_title = discovery_record.publisher_provider
      end

      @reserve.creator = discovery_record.creator_contributor

      @reserve.details = discovery_record.details

      if synchronize_url_from_meta_data?
        @reserve.url = discovery_record.fulltext_url
      end

      @reserve.overwrite_nd_meta_data = false
      @reserve.metadata_synchronization_date = Time.now

      @reserve.save!
    end


    def synchronize_url_from_meta_data?
      @reserve.url.nil? && electionic_resource_policy.can_have_url_resource? && discovery_record.fulltext_available?
    end


    def discovery_record
      @discovery_record ||= DiscoveryApi.search_by_ids(@reserve.nd_meta_data_id).first
    end


    def electionic_resource_policy
      @policy ||= ElectronicReservePolicy.new(@reserve)
    end
end
