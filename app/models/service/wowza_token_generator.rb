require 'digest/md5'
require 'securerandom'


class WowzaTokenGenerator

  def self.generate(username, ip)
    new().generate(username, ip)
  end

  def generate(username, ip)
    return @database_token if @database_token

    puts username
    puts ip

    @database_token = WowzaToken.where( username: username, ip: ip).first
    puts @database_token.inspect
    @database_token ||= WowzaToken.create( username: username, ip: ip, token: hashed_token, timestamp: Time.now.to_i )
    puts @database_token.inspect
    puts "----->"
    @database_token
  end

  def token
    @token ||= SecureRandom.hex
  end

  private

    def hashed_token
      Digest::MD5.hexdigest(token)
    end

end
