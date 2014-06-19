class GetStreamingReserve
  include GetCourse
  include ModelErrorTrapping
  include RailsHelpers

  attr_accessor :reserve, :controller

  delegate :id, :creator_contributor, :details, :publisher_provider, to: :reserve

  def initialize(controller)
    @controller = controller

    params = controller.params

    @reserve = reserve_search.get(params[:id])
  end


  def android?
    !!(request_os =~ /android/i)
  end


  def video_player
    if android?
      jwplayer.rstp_link
    else
      jwplayer.jwplayer
    end
  end


  def course
    reserve.course
  end


  private

    def jwplayer
      @jwplayer = Jwplayer.new(streaming_filename)
    end


    def streaming_filename
      @filename ||= ElectronicReservePolicy.new(@reserve).streaming_download_file
    end


    def request_os
      @android_agent ||= user_agent_parser.parse(controller.request.env['HTTP_USER_AGENT'])
      @android_agent.os.to_s
    end


    def user_agent_parser
      @usp ||= UserAgentParser::Parser.new
    end


    def reserve_requires_approval?
      ReserveRequiresTermsOfServiceAgreement.new(reserve).requires_agreement?
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end
end
