class WowzaUrlGenerator
  BASE_URL = "wowza.library.nd.edu:1935/vod/mp4:"

  attr_accessor :filename

  def initialize(filename, username, ipaddress, specific_token = false)
    @filename = filename
    @username = username
    @ipaddress = ipaddress
    @specific_token = specific_token
  end


  def html5
    "http://#{BASE_URL}#{filename}/playlist.m3u8?#{token}"
  end


  def rtmp
    "rtmpt://#{BASE_URL}#{filename}?#{token}"
  end


  def rtsp
    "rtsp://#{BASE_URL}#{filename}?#{token}"
  end


  private

    def wowza_token_generator
      @token_generator ||= WowzaTokenGenerator.new
    end


    def token
      if @specific_token
        "t=#{@specific_token}"
      else
        wowza_token_generator.generate(@username, @ipaddress)
        "t=#{wowza_token_generator.token}"
      end
    end
end
