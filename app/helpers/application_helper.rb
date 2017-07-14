module ApplicationHelper

  def url_for(options = {})
    original = super(options)
    return original unless (request.path.starts_with?('/sakai') && !original.starts_with?('/sakai'))
    original.gsub(/^\//, '/sakai/')
  end


  def user_top_nav()
    render partial: '/layouts/user_nav',
      locals: { user_course_listing: ListUsersCourses.new(current_user) }
  end


  def sakai_top_nav
    render partial: '/layouts/sakai_nav',
                locals: { user_course_listing: ListUsersCourses.new(current_user) }
  end


  def library_select_form(f, label = "")
    f.input :library,
      as: "select",
      wrapper_html: { id: 'library_select_list' },
      collection: { 'Hesburgh Library' => :hesburgh , 'Architecture Library' => :architecture, 'Chemistry - Physics Library' => :chem, 'Engineering Library' => :engineering, 'Mahaffey Business Library' => :business, 'O\' Meara Mathematics Library' => :math },
      :default => 'Hesburgh',
      label: label
  end


  def permission
    @permission ||= Permission.new(current_user, self)
  end


  def masquerade
    @masquerade ||= Masquerade.new(self)
  end


  def how_to_use_page_link(txt)
    link_to(image_tag("help.png") + " How to use this page.", 'javascript:void(0);', onclick: txt)
  end


  def help_required_message
    raw "<br><strong>#{t('form_help.required')}</strong>"
  end

  def help_optional_message
    raw "<br><strong>#{t('form_help.optional')}</strong>"
  end



  def new_instructor_reserve(type)
    if @request_reserve && @request_reserve.type == type
      return @request_reserve
    else
      @new_reserve
    end
  end


    # Includes JWPlayer javascript library
    def jwplayer_assets
      javascript_include_tag "jwplayer"
    end


    def jwplayer(file_name, options = {})
      sources =  [{
            file: "https://wowza.library.nd.edu:443/vod/mp4:#{file_name}/playlist.m3u8"
        },{
            file: "rtmps://wowza.library.nd.edu:443/vod/mp4:#{file_name}"
        }
      ]

      options = { fallback: false, primary: 'flash', id: 'jwplayer', html5player: '/assets/jwplayer.html5.js', flashplayer: '/assets/jwplayer.flash.swf', autostart: true, sources: sources }.merge(options)

      result = %Q{<div id='#{options[:id]}'>Loading the player...</div>
                  <script type='text/javascript'>
                    jwplayer('#{options[:id]}').setup(#{options.except(:id).to_json});
                  </script>
                  <a href="rtsps://wowza.library.nd.edu:443/vod/mp4:#{file_name}">Android</a>
                }

      result.respond_to?(:html_safe) ? result.html_safe : result
    end

end
