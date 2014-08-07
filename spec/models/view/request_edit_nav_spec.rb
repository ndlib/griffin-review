require 'spec_helper'

describe RequestEditNav do

  describe :meta_data_notes do
    let(:reserve) { double(Reserve, nd_meta_data_id: nil) }
    subject { described_class.new(reserve) }

    it "adds a note about physical items needing to be in aleph if they are not" do
      expect(subject).to receive(:physical_reserve?).and_return(true)
      expect(subject).to receive(:reserve_in_aleph?).and_return(false)
      expect(subject).to receive(:meta_data_policy).at_least(:once).and_return(double(ReserveMetaDataPolicy, meta_data_id_required?: true, complete?: true))

      expect(subject.meta_data_notes).to include("This reserve has not been found in the nightly aleph export.  Make sure it has been entered into aleph.")
    end

  end
end
