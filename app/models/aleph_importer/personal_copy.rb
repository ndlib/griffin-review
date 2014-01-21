class AlephImporter::PersonalCopy


  def initialize(aleph_reserve)
    @aleph_reserve = aleph_reserve
  end


  def personal_copy?
    @aleph_reserve['sid'].match(/NDU30/)
  end



end
