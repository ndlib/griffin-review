class Jwplayer
  include RailsHelpers

  attr_accessor :filename

  def initialize(filename)
    @filename = filename
  end


  def jwplayer(options = {})
    options = default_options.merge(options)

    result = %Q{<div id='#{options[:id]}'>Loading the player...<br><a href="/documentation/troubleshooting" target="blank" class="btn">Trouble Viewing the Material?</a></div><script type='text/javascript'>jwplayer('#{options[:id]}').setup(#{options.except(:id).to_json});</script>}

    result.respond_to?(:html_safe) ? result.html_safe : result
  end


  def rstp_link(options = {})
    options = default_options.merge(options)

    result = %Q{<div id='#{options[:id]}'>#{helpers.link_to("Play Video", wowza_url_generator.rtsp)}</div>}
    result.respond_to?(:html_safe) ? result.html_safe : result
  end


  private

    def default_options
      {
        fallback: false,
        primary: 'html5',
        id: 'jwplayer',
        html5player: '/assets/jwplayer.html5.js',
        flashplayer: '/assets/jwplayer.flash.swf',
        autostart: true,
        width: "100%",
        aspectratio: "16:9",
        playlist: [ { sources: sources}
        ]
      }
    end


    def sources
      [{
          file: wowza_url_generator.html5,
      },{
          file: wowza_url_generator.rtmp
      }]
    end


    def wowza_url_generator
      @wowza_url_generator ||= WowzaUrlGenerator.new(filename)
    end

end
