require 'spec_helper'


describe WowzaTokenGenerator do
  subject { described_class.new() }

  describe :token do

    it "generates a token from securerandom" do
      expect(Digest::MD5).to receive(:hexdigest).and_return("token").with('username')
      expect(subject.send('token', 'username')).to eq("token")
    end
  end


  describe :generate do
    it "creates a database token with a username" do
      subject.generate('username', 'ipaddress')
      expect(WowzaToken.where( username: 'username').size).to eq(1)
    end

    it "creates a database token with a ipaddress" do
      subject.generate('username', 'ipaddress')
      expect(WowzaToken.where( ip: 'ipaddress').size).to eq(1)
    end

    it "creates a timestamp" do
      subject.generate('username', 'ipaddress')
      expect(WowzaToken.where(username: 'username', ip: 'ipaddress').first.timestamp).to eq(Time.now.to_i)
    end

    it "reuses a token for the same username and ip address " do
      token = subject.generate('username', 'ipaddress')
      subject.generate('username', 'ipaddress')

      expect(WowzaToken.where(username: 'username', ip: 'ipaddress').size).to eq(1)
    end

    it "creates a database token with a ipaddress" do
      subject.stub(:hashed_token).and_return("token")
      subject.generate('username', 'ipaddress')

      expect(WowzaToken.where(username: 'username', ip: 'ipaddress').first.token).to eq("token")
    end
  end

end
