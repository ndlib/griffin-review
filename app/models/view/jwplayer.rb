class Jwplayer
  include RailsHelpers

  attr_reader :reserve, :username, :ipaddress, :specific_token

  def initialize(reserve, username, ipaddress, specific_token = false)
    @reserve = reserve
    @username = username
    @ipaddress = ipaddress
    @specific_token = specific_token

  end

  def jwplayer(options = {})
    options = default_options.merge(options)

    result = %Q{<div id='#{options[:id]}'>Loading the player...<h3>Troubleshooting</h3><ol><li>We recommend using <a href="https://www.google.com/intl/en/chrome/browser/" target="_blank">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('#{options[:id]}').setup(#{options.except(:id).to_json});</script>}

    result.respond_to?(:html_safe) ? result.html_safe : result
  end

  def rstp_link(options = {})
    options = default_options.merge(options)

    result = %Q{<div id='#{options[:id]}'>#{rtsp_links.join(helpers.raw("<br>"))}</div>}
    result.respond_to?(:html_safe) ? result.html_safe : result
  end

  private

    def rtsp_links
      ret = []
      playlist_files.each do | row |
        generator = wowza_url_generator(row[:file])
        ret << helpers.link_to(row[:title], generator.rtsp)
      end

      ret
    end

    def default_options
      opts = {
        fallback: false,
        primary: 'html5',
        id: 'jwplayer',
        playlist: sources,
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
      ao.merge!( {
        width: '80%'
        height: 32,
      })

      ao
    end

    def multiple?
      playlist_files.size > 1
    end

    def audio_playlist?
      reserve.type == 'AudioReserve'
    end

    def video_playlist?
      reserve.type == 'VideoReserve'
    end

    def sources
      ret = []

      playlist_files.each do | row |
        if row[:file].blank?
          ret << {
            sources: [{
                file: wowza_category_file.html5
            }],
            title: row[:title]
          }
        elsif audio_playlist?
          ret << {
            sources: sources_for_filename(row[:file]),
            title: row[:title]
          }
        else
           ret << { sources: sources_for_filename(row[:file]),
            title: row[:title]
          }
        end
      end

      ret
    end

    def playlist_files
      if reserve.media_playlist && reserve.media_playlist.rows.size > 0
        reserve.media_playlist.rows
      elsif reserve.url
        [{file: reserve.url, title: reserve.title}]
      else
        []
      end
    end

    def sources_for_filename(filename)
      generator = wowza_url_generator(filename)

      [{ file: generator.html5 }]
    end

    def wowza_url_generator(filename)
      type = audio_playlist? ? 'audio' : 'video'

      WowzaUrlGenerator.new(filename, type, username, ipaddress, specific_token)
    end


    def wowza_category_file
      @category ||= WowzaUrlGenerator.new('4sec.mp3', 'audio', username, ipaddress, specific_token)
    end
end
