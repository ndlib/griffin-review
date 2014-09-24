class MediaPlaylist < ActiveRecord::Base

  validates :item_id, :rows, presence: true

  store :data, accessors: [:rows]

  self.inheritance_column = nil

end
