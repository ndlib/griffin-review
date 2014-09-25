require 'digest/md5'
require 'securerandom'


class WowzaTokenGenerator

  def self.generate(username, ip)
    obj = new()
    obj.generate(username, ip)
  end

  def generate(username, ip)
    return @database_token if @database_token
    @database_token = WowzaToken.where( username: username, ip: ip).first
    @database_token ||= WowzaToken.create( username: username, ip: ip, token: hashed_token, unhashed_token: token(username), timestamp: Time.now.to_i )

    token(username)
  end

  private

    def token(username)
      @token = Digest::MD5.hexdigest(username)
      # @token ||= SecureRandom.hex
    end

    def hashed_token
      Digest::MD5.hexdigest(token)
    end

end
