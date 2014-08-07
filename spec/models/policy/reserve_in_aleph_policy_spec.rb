require 'spec_helper'


describe ReserveInAlephPolicy do

  describe :in_aleph? do
    context :reserve_in_aleph do
      let(:reserve) { double(Reserve, currently_in_aleph: true)}
      subject { described_class.new(reserve)}

      it "returns true" do
        expect(subject.in_aleph?).to be_true
      end
    end

    context :reserve_not_in_aleph do
      let(:reserve) { double(Reserve, currently_in_aleph: false)}
      subject { described_class.new(reserve)}

      it "returns true" do
        expect(subject.in_aleph?).to be_false
      end
    end

  end

end
