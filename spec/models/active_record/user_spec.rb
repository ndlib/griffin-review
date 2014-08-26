require 'spec_helper'

describe User do
  subject { described_class.new }

  it "downcases the username no matter what was entered" do
    subject.username = "UPPER"
    expect(subject.username).to eq("upper")
  end


  it "strips the username no matter what was entered" do
    subject.username = " strip"
    expect(subject.username).to eq("strip")
  end

  describe 'admin_preferences' do
    [:libraries, :types, :reserve_type, :instructor_range_begin, :instructor_range_end].each do |method|
      it "stores #{method}" do
        expect(subject).to respond_to(method)
        subject.send("#{method}=", method.to_s)
        expect(subject.send(method)).to eq(method.to_s)
      end
    end
  end

end
