class DocumentationController < ApplicationController

  skip_before_filter :authenticate_user!

  layout :determine_layout

  def index
    render
  end


  def show
    @layout = params[:in_modal] ? false : true
    id = parse_id
    @title = id[0]
    @page_title = "#{@title.titleize} FAQ"
    @nav = "#{@title}_nav"
    @translation = "documentation.#{id.join('.')}"

    I18n.t "#{@translation}_html", :raise => true rescue raise_404

    render layout: @layout
  end


  def troubleshooting
  end


  private


  def parse_id
    params[:id].split('-')
  end
end
