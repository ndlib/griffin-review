require 'digest/md5'
require 'securerandom'


class WowzaTokenGenerator

  def self.generate(username, ip)
    obj = new()
    obj.generate(username, ip)
  end

  def generate(username, ip)
    return @database_token if @database_token
    @database_token = WowzaToken.where( username: username, ip: ip).first || WowzaToken.create( username: username, ip: ip, token: hashed_token(username), timestamp: Time.now.to_i )

    if @database_token.timestamp < 5.minutes.ago.to_i
      @database_token.timestamp = Time.now.to_i
      @database_token.save!
    end

    token(username)
  end

  private

    def token(username)
      Digest::MD5.hexdigest(username)
    end

    def hashed_token(username)
      Digest::MD5.hexdigest(token(username))
    end

end
