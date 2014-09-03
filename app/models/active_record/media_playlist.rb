class MediaPlaylist < ActiveRecord::Base

  validates :item_id, presence: true

  store :data, accessors: [:rows]

end
