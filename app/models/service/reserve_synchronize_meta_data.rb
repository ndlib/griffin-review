class ReserveSynchronizeMetaData
  attr_reader :reserve

  def initialize(reserve)
    @reserve = reserve
  end


  def check_synchronized!
    if can_be_synchronized?
      synchonize!
    end
  end


  def valid_discovery_id?
    discovery_record.present?
  end


  private

    def can_be_synchronized?
      !@reserve.overwrite_nd_meta_data?
    end


    def synchonize!
      return if !valid_discovery_id?

      @reserve.title =  discovery_record.title
      @reserve.creator = discovery_record.creator_contributor
      @reserve.journal_title = discovery_record.publisher_provider
      @reserve.details = discovery_record.details

      if synchronize_url_from_meta_data?
        @reserve.url = discovery_record.fulltext_url
      end

      @reserve.metadata_synchronization_date = Time.now

      @reserve.save!
    end


    def synchronize_url_from_meta_data?
      @reserve.url.nil? && reserve_resource_policy.can_have_url_resource? && !reserve_resource_policy.streaming_service_resource? && discovery_record.fulltext_available?
    end


    def discovery_record
      @discovery_record ||= DiscoveryApi.search_by_ids(@reserve.nd_meta_data_id).first
    end


    def reserve_resource_policy
      @policy ||= ReserveResourcePolicy.new(@reserve)
    end
end
