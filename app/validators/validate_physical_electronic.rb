class ValidatePhysicalElectronic < ActiveModel::Validator
  def validate(record)
    if !record.physical_reserve && !record.electronic_reserve
      record.errors[:physical_reserve] = 'A reserve may not have be neither an electronic or physical reserve.'
    end
  end
end
