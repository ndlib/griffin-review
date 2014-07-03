require 'spec_helper'


describe WowzaTokenGenerator do
  subject { described_class.new() }

  describe :token do

    it "generates a token from securerandom" do
      expect(SecureRandom).to receive(:hex).and_return("token")
      expect(subject.token).to eq("token")
    end
  end


  describe :generate do
    it "creates a database token with a username" do
      expect(subject.generate('username', 'ipaddress').username).to eq("username")
    end

    it "creates a database token with a ipaddress" do
      expect(subject.generate('username', 'ipaddress').ip).to eq("ipaddress")
    end


    it "creates a database token with a ipaddress" do
      subject.stub(:hashed_token).and_return("token")
      expect(subject.generate('username', 'ipaddress').token).to eq("token")
    end
  end

end
