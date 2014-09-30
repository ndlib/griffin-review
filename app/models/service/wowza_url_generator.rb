class WowzaUrlGenerator

  attr_reader :type, :username, :ipaddress, :specific_token

  def initialize(filename, type, username, ipaddress, specific_token = false)
    @filename = filename
    @type = type
    @username = username
    @ipaddress = ipaddress
    @specific_token = specific_token
  end

  def html5
    "http://#{base_url}#{wowza_application}/#{filename}/playlist.m3u8?#{token}"
  end

  def rtmp
    "rtmpt://#{base_url}#{wowza_application}?#{token}#{filename}"
  end

  def rtsp
    "rtsp://#{base_url}#{filename}?#{token}"
  end

  private

    def wowza_token
      @wowza_token ||= WowzaTokenGenerator.generate(username, ipaddress)
    end

    def filename
      "#{base_directory}#{@filename.gsub(' ', '%20')}"
    end

    def token
      if specific_token
        "t=#{specific_token}"
      elsif Rails.env == 'development'
        "t=!localtoken662778!"
      else
        "t=#{wowza_token}"
      end
    end

    def wowza_application
      'vod'
    end

    def base_directory
      if @type == 'audio'
        'mp3:StreamingAudio/MP3/'
      elsif @type == 'video'
        'mp4:StreamingVideo/'
      else
        raise "Invalid type, #{@type} passed into WowzaUrlGenerator"
      end
    end

    def base_url
      if Rails.env == 'production'
        "wowza.library.nd.edu:1935/"
      else
        "wowza-pprd-vm.library.nd.edu:1935/"
      end
    end
end
