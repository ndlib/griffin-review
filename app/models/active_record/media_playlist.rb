class MediaPlaylist < ActiveRecord::Base

  validates :item_id, :type, :rows, presence: true
  validates :type, inclusion: { in: %w(audio video) }

  store :data, accessors: [:rows]

  self.inheritance_column = nil

end
