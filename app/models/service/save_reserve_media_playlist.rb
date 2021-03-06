class SaveReserveMediaPlaylist
  attr_accessor :reserve

  def self.call(reserve)
    object = new(reserve)
    yield(object) if block_given?
    object.create
  end

  def initialize(reserve)
    @reserve = reserve
  end

  def add_row(title, file)
    media_playlist.rows ||= []
    if !title.nil? && title.present?
      media_playlist.rows << { title: title, file: file }
    end
  end

  def create()
    if media_playlist.valid?
      persist!
      reserve.media_playlist = media_playlist
    else
      false
    end
  end

  private

    def persist!
      media_playlist.save!
    end

    def media_playlist
      return @playlist if @playlist

      if reserve.media_playlist.present?
        reserve.media_playlist.destroy
      end

      @playlist = MediaPlaylist.new(item_id: reserve.item_id)
    end
end

