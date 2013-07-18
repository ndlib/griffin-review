class ReserveSynchronizeMetaData

  def initialize(reserve)
    @reserve = reserve
  end


  def check_synchronized!
    if needs_to_be_synchronized?
      synchonize!
    end
  end


  private

    def needs_to_be_synchronized?
      !@reserve.overwrite_nd_meta_data? &&
        @reserve.nd_meta_data_id.present? &&
        (@reserve.metadata_synchronization_date.nil? || @reserve.metadata_synchronization_date <= 10.days.ago)
    end


    def synchonize!
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
