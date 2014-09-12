class AdminUpdateResource
  attr_reader :reserve

  include RailsHelpers
  include Virtus
  include ModelErrorTrapping

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :reserve

  attribute :pdf, String
  attribute :url, String
  attribute :playlist_rows, Array
  attribute :playlist_type, String
  attribute :playlist_file, ActionDispatch::Http::UploadedFile

  delegate :workflow_state, :id, to: :reserve


  def initialize(current_user, params)
    @reserve = reserve_search.get(params[:id], nil)
    @current_user = current_user

    if params[:admin_update_resource]
      self.attributes = params[:admin_update_resource]
    elsif electronic_reserve.has_media_playlist?
      self.playlist_type = reserve.media_playlist.type
      self.playlist_rows = reserve.media_playlist.rows
    end

    validate_input!

    check_is_complete!
  end


  def has_resource?
    electronic_reserve.has_resource?
  end

  def media_playlist?
    electronic_reserve.has_media_playlist?
  end


  def current_resource_type
    electronic_reserve.electronic_resource_type
  end


  def current_resource_name
    electronic_reserve.resource_name
  end


  def delete_link
    DeleteReserveElectronicResourceForm.new(@reserve).delete_link
  end


  def default_to_streaming?
    @reserve.type == 'VideoReserve' || @reserve.type == 'AudioReserve'
  end

  def sipx_button
    helpers.link_to(helpers.raw("<i class=\"icon icon-arrow-up\"></i> Go To Sipx</a>"), routes.course_sipx_admin_redirect_path(course.id), class: "btn", target: "_blank")
  end

  def course
    @reserve.course
  end

  def save_resource
    if valid?
      persist!
      true
    else
      false
    end
  end


  private

    def check_is_complete!
      ReserveCheckInprogress.new(@reserve).check!
    end


    def validate_input!
      if !electronic_reserve.is_electronic_reserve?
        raise_404
      end
    end


    def persisted?
      false
    end


    def persist!
      @reserve.pdf = pdf
      @reserve.url = url

      create_new_playlist!

      @reserve.save!

      ReserveCheckIsComplete.new(@reserve).check!
    end

    def remove_current_playlist!
      if reserve.media_playlist.present?
        reserve.media_playlist.destroy
      end
    end

    def create_new_playlist!
      SaveReserveMediaPlaylist.call(@reserve, playlist_type) do | srmp |
        determine_playlist_rows.each do | row |
          srmp.add_row(row['title'], row['filename'])
        end
      end
    end

    def reserve_search
      @search ||= ReserveSearch.new
    end


    def electronic_reserve
      @epolicy ||= ElectronicReservePolicy.new(@reserve)
    end


    def determine_playlist_rows
      if playlist_rows.present?
        playlist_rows
      elsif playlist_file
        ParsePlaylistCsv.rows(playlist_file)
      else
        []
      end
    end

end
