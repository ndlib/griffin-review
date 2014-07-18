class Jwplayer
  include RailsHelpers

  attr_accessor :filename

  def initialize(filename, username, ipaddress, specific_token = false)
    @filename = filename
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
      @wowza_url_generator ||= WowzaUrlGenerator.new(filename, @username, @ipaddress, @specific_token)
    end

end
