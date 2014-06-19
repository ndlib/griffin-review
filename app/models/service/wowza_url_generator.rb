class WowzaUrlGenerator
  BASE_URL = "wowza.library.nd.edu:1935/vod/mp4:"

  attr_accessor :filename

  def initialize(filename)
    @filename = filename
  end


  def html5
    "http://#{BASE_URL}#{filename}/playlist.m3u8"
  end


  def rtmp
    "rtmpt://#{BASE_URL}#{filename}"
  end


  def rtsp
    "rtsp://#{BASE_URL}#{filename}"
  end
end
