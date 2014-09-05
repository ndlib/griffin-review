class SaveReserveMediaPlaylist
  attr_accessor :reserve

  def self.call(reserve)
    object = new(reserve)
    object.reset
    yield(object)
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
      @playlist ||= @reseve.media_playlist || MediaPlaylist.new(item_id: reserve.item_id)
    end
end

