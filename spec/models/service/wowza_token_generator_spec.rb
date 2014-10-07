require 'spec_helper'


describe WowzaTokenGenerator do
  subject { described_class.new('username', 'ipaddress') }

  describe :token do

    it "generates a token from the username" do
      expect(Digest::MD5).to receive(:hexdigest).and_return("token").with('username')
      expect(subject.send('token')).to eq("token")
    end
  end


  describe :generate do
    it "creates a database token with a username" do
      subject.generate()
      expect(WowzaToken.where( username: 'username').size).to eq(1)
    end

    it "creates a database token with a ipaddress" do
      subject.generate()
      expect(WowzaToken.where( ip: 'ipaddress').size).to eq(1)
    end

    it "creates a timestamp" do
      subject.generate()
      expect(WowzaToken.where(username: 'username', ip: 'ipaddress').first.timestamp).to eq(Time.now.to_i)
    end

    it "reuses a token for the same username and ip address " do
      subject.generate()
      described_class.new('username', 'ipaddress').generate

      expect(WowzaToken.where(username: 'username', ip: 'ipaddress').size).to eq(1)
    end

    it "creates a database token with a ipaddress" do
      subject.stub(:hashed_token).and_return("token")
      subject.generate()

      expect(WowzaToken.where(username: 'username', ip: 'ipaddress').first.token).to eq("token")
    end

    it "removes all the tokens if there is more then one result" do
      result = double(size: 2, first: nil)
      WowzaToken.stub(:where).and_return(result)

      expect(result).to receive(:destroy_all)
      subject.generate()
    end
  end

end
