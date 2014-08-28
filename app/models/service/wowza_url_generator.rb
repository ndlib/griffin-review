class WowzaUrlGenerator

  attr_accessor :filename

  def initialize(filename, username, ipaddress, media_type, specific_token = false)
    @filename = filename
    @username = username
    @ipaddress = ipaddress
    @specific_token = specific_token
    @media_type = media_type

  end


  def html5
    "http://#{base_url}/#{media_string}#{filename}/playlist.m3u8?#{token}"
  end


  def rtmp
    "rtmpt://#{base_url}/#{media_string}#{filename}?#{token}"
  end


  def rtsp
    "rtsp://#{base_url}/#{media_string}#{filename}?#{token}"
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



    def base_url
      if Rails.env == 'production'
        "wowza.library.nd.edu:1935"
      else
        "wowza-pprd-vm.library.nd.edu:1935"
      end
    end

    def media_string
      if @media_type == "video"
        "vod/mp4:"
      else
        "aod/_definst_/mp3:"
      end
    end
end
