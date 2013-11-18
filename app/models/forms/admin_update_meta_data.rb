class AdminUpdateMetaData
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :reserve

  attribute :title, String
  attribute :creator, String
  attribute :details, String
  attribute :publisher, String
  attribute :journal_title, String
  attribute :length, String
  attribute :chapter_title, String
  attribute :nd_meta_data_id, String
  attribute :display_length, String
  attribute :on_order, Boolean
  attribute :overwrite_nd_meta_data, Boolean

  #validates :nd_meta_data_id, presence: true, if: :requires_nd_meta_data_id?
  validates :title, presence: true, unless: :requires_nd_meta_data_id?

  validates_with ValidateMetaDataId, if: :requires_nd_meta_data_id?


  delegate :id, :workflow_state, :semester, :type, :creator_contributor, :publisher_provider, to: :reserve

  def initialize(current_user, params)
    @reserve = reserve_search.get(params[:id], nil)

    self.attributes.each_key do |key|
      self.send("#{key}=", @reserve.send(key))
    end

    if params[:admin_update_meta_data]
      self.attributes = params[:admin_update_meta_data]
      self.nd_meta_data_id = self.nd_meta_data_id.strip
    end

    self.overwrite_nd_meta_data ||= false

    ReserveCheckInprogress.new(@reserve).check!
  end


  def reserve_id
    @reserve.id
  end


  def persisted?
    false
  end


  def save_meta_data
    if valid?
      persist!
      true
    else
      false
    end
  end


  def reserve
    @reserve
  end


  def overwrite_nd_meta_data?
    overwrite_nd_meta_data
  end


  def title_field_name
    if @reserve.type == 'BookReserve' || @reserve.type == 'BookChapterReserve'
      "Book Title"
    elsif @reserve.type == 'JournalReserve'
      "Article Title"
    elsif @reserve.type == 'VideoReserve'
      "Video Title"
    else
      "Title"
    end
  end


  def catalog_search_href
    search_term = CGI.escape(@reserve.title)
    if @reserve.type == 'VideoReserve'
      "http://onesearch.library.nd.edu/primo_library/libweb/action/search.do?dscnt=0&vl(16772486UI3)=videos&scp.scps=scope%3A%28hathi_pub%29%2Cscope%3A%28ndulawrestricted%29%2Cscope%3A%28dtlrestricted%29%2Cscope%3A%28NDU%29%2Cscope%3A%28NDLAW%29%2Cscope%3A%28ndu_digitool%29&tab=nd_campus&dstmp=1384462729064&srt=rank&mode=Advanced&vl(1UIStartWith1)=contains&indx=1&tb=t&vl(freeText0)=#{search_term}&vid=NDU&fn=search&vl(freeText2)=&vl(24400451UI4)=all_items&frbg=&ct=search&vl(1UIStartWith2)=contains&vl(16833818UI1)=any&dum=true&vl(16833819UI2)=any&vl(1UIStartWith0)=contains&vl(16833817UI0)=title&Submit=Search&vl(freeText1)="
    elsif @reserve.type == 'BookReserve' || @reserve.type == 'BookChapterReserve'
      "http://onesearch.library.nd.edu/primo_library/libweb/action/search.do?dscnt=0&vl(16772486UI3)=books&scp.scps=scope%3A%28hathi_pub%29%2Cscope%3A%28ndulawrestricted%29%2Cscope%3A%28dtlrestricted%29%2Cscope%3A%28NDU%29%2Cscope%3A%28NDLAW%29%2Cscope%3A%28ndu_digitool%29&tab=nd_campus&dstmp=1384463665396&srt=rank&mode=Advanced&vl(1UIStartWith1)=contains&indx=1&tb=t&vl(freeText0)=#{search_term}&fn=search&vid=NDU&vl(freeText2)=&title1=1&vl(24400451UI4)=all_items&frbg=&ct=search&vl(16833818UI1)=any&vl(1UIStartWith2)=contains&dum=true&vl(16833819UI2)=any&vl(1UIStartWith0)=contains&vl(16833817UI0)=title&Submit=Search&vl(freeText1)="
    else
      ""
    end
  end


  private

    def requires_nd_meta_data_id?
      ReserveMetaDataPolicy.new(@reserve).meta_data_id_required?
    end


    def requires_creator?

    end


    def requires_journal?

    end


    def requires_publisher?

    end



    def persist!
      @reserve.attributes = self.attributes

      @reserve.save!

      synchronize_meta_data!

      ReserveCheckIsComplete.new(@reserve).check!
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end


    def synchronize_meta_data!
      if requires_nd_meta_data_id?
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
      end
    end

end

