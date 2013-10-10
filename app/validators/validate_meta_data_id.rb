class ValidateMetaDataId < ActiveModel::Validator
  def validate(record)
    return if record.nd_meta_data_id.nil?

    record.reserve.nd_meta_data_id = record.nd_meta_data_id

    r = ReserveSynchronizeMetaData.new(record.reserve)
    if record.nd_meta_data_id.downcase.match(/^dedup/)
      record.errors[:nd_meta_data_id] << 'Record Id cannot take the dedup id from primo.  Please choose on of the other record ids.'
    elsif !r.valid_discovery_id?
      record.errors[:nd_meta_data_id] << 'Unable to find the record id.  Verify that the id you have pasted in is correct. '
    end
  end
end

