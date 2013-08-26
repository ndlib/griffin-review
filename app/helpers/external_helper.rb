module ExternalHelper
    # Includes the relevant library SSI file from http://library.nd.edu/ssi/<filename>.shtml

    def download_ssi_file(filename)
      require 'open-uri'
      ssi_url = "http://library.nd.edu/ssi/#{filename}.shtml"
      f = open(ssi_url, "User-Agent" => "Ruby/#{RUBY_VERSION}")
      contents = f.read
    end

    def parse_ssi_contents(contents)
      # Modify any href and src starting with "/" to start with "https://library.nd.edu/"
      contents.gsub(/(href|src)="\//,"\\1=\"https://library.nd.edu/")
    end

    # Since we're in the context of a Rails application with its own javascript assets, we want to remove any library site javascripts we don't need
    def clean_ssi_js(contents)
      contents.gsub(/^.*(jquery|simplegallery|main|local).*\n?/,"")
    end

    def set_page_title(title)
      @page_title = title
    end

    def page_title()
      @page_title
    end

    def add_crumb(content)
      @hesburgh_breadcrumb_links ||= []
      @hesburgh_breadcrumb_links << content
    end

    def render_breadcrumb
      breadcrumb_content = link_to("Hesburgh Libraries", "/")
      if @hesburgh_breadcrumb_links.present?
        @hesburgh_breadcrumb_links.each do |link|
          breadcrumb_content += raw(" &gt; ") + link
        end
      end
      if page_title.present?
        breadcrumb_content += raw(" &gt; ") + page_title
      end
      content_tag(:div, breadcrumb_content, :id => "crumbs", :class => "span-24 last")
    end
end
