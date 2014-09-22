class Jwplayer
  include RailsHelpers

  attr_reader :media_playlist, :username, :ipaddress, :specific_token

  def initialize(media_playlist, username, ipaddress, specific_token = false)
    @media_playlist = media_playlist
    @username = username
    @ipaddress = ipaddress
    @specific_token = specific_token

  end


  def jwplayer(options = {})
    options = default_options.merge(options)

    result = %Q{<div id='#{options[:id]}'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href="http://get.adobe.com/flashplayer/" target="_blank">flash</a> installed.</li><li>We recommend using <a href="https://www.google.com/intl/en/chrome/browser/" target="_blank">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('#{options[:id]}').setup(#{options.except(:id).to_json});</script>}

    result.respond_to?(:html_safe) ? result.html_safe : result
  end


  def rstp_link(options = {})
    options = default_options.merge(options)

    result = %Q{<div id='#{options[:id]}'>#{helpers.link_to("Play Video", rstp_url)}</div>}
    result.respond_to?(:html_safe) ? result.html_safe : result
  end


  def rstp_url
    wowza_url_generator.rtsp
  end


  private


    def default_options
      opts = {
        fallback: false,
        primary: 'html5',
        id: 'jwplayer',
        html5player: '/assets/jwplayer.html5.js',
        flashplayer: '/assets/jwplayer.flash.swf',
        playlist: sources,
        androidhls: true,
        logo: { file:"/assets/hesburgh.png", link:"http://library.nd.edu"},
      }

      if video_playlist?
        opts.merge(video_options)
      else
        opts.merge(audio_options)
      end
    end

    def video_options
      vo = {
        autostart: true,
        aspectratio: "16:9",
        width: '80%'
      }

      if multiple?
        vo.merge!( {
        listbar: {
          position: "right",
          size: '20%',
          layout: 'basic'
        }})
      end

      vo
    end


    def audio_options
      ao = {
        autostart: false,
      }

      if multiple?
        ao.merge!( {
          width: 480,
          height: 480,
          listbar: {
            position: "bottom",
            size: '400',
            layout: 'basic'
        }})
      else
        ao.merge!( {
          width: 480,
          height: 56,
        })
      end

      ao
    end


    def multiple?
      media_playlist.rows.size > 1
    end


    def audio_playlist?
      media_playlist.type == 'audio'
    end


    def video_playlist?
      media_playlist.type == 'video'
    end


    def sources
      ret = []

      media_playlist.rows.each do | row |
        ret << {
          sources: [{
              file: wowza_url_generator(row[:file]).rtmp
          },{
              file: wowza_url_generator(row[:file]).html5,
          }],
          title: row[:title]
        }
      end

      ret
    end


    def wowza_url_generator(filename)
      @wowza_url_generator ||= WowzaUrlGenerator.new(filename, media_playlist.type, username, ipaddress, specific_token)
    end


end
