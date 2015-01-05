require 'digest/md5'
require 'securerandom'


class WowzaTokenGenerator
  attr_reader :database_token, :username, :ip

  def self.generate(username, ip)
    obj = new(username, ip)
    obj.generate
  end

  def initialize(username, ip)
    @username = username
    @ip = ip
  end

  def generate
    return database_token if database_token

    build_database_token
    verify_token_timestamp

    token
  end

  private

    def token
      Digest::MD5.hexdigest(username)
    end

    def hashed_token
      Digest::MD5.hexdigest(token)
    end

    def build_database_token
      tokens = WowzaToken.where(username: username)
      if tokens.size > 1
        tokens.destroy_all
      end

      @database_token = tokens.first || WowzaToken.create( username: username, ip: ip, token: hashed_token, timestamp: Time.now.to_i )

    end

    def verify_token_timestamp
      if database_token.timestamp < 5.minutes.ago.to_i || database_token.ip != ip
        database_token.timestamp = Time.now.to_i
        database_token.ip = ip
        database_token.save!
      end
    end
end
