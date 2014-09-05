class SaveReserveMediaPlaylist
  attr_accessor :reserve

  def self.call(reserve)
    object = new(reserve)
    object.reset
    yield(object) if block_given?
    object.create
  end

  def initialize(reserve)
    @reserve = reserve
  end

  def add_row(title, file)
    media_playlist.rows << { title: title, file: file }
  end

  def create()
    if media_playlist.valid?
      persist!
      media_playlist
    else
      false
    end
  end

  def reset
    media_playlist.rows = []
  end

  private

    def persist!
      media_playlist.save!
    end

    def media_playlist
      return @playlist if @playlist

      if reserve.media_playlist.nil?
        reserve.media_playlist = MediaPlaylist.new(item_id: reserve.item_id)
      end

      @playlist = reserve.media_playlist
    end
end

