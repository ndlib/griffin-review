require 'digest/md5'
require 'securerandom'


class WowzaTokenGenerator

  def self.generate(username, ip)
    new().generate(username, ip)
  end


  def generate(username, ip)
    @database_token ||= WowzaToken.create( username: username, ip: ip, token: hashed_token, timestamp: Time.now.to_i )
  end


  def token
    @token ||= SecureRandom.hex
  end


  private

    def hashed_token
      Digest::MD5.hexdigest(token)
    end

end
