class MediaPlaylist < ActiveRecord::Base

  validates :item_id, :type, presence: true
  validates :type, inclusion: { in: %w(audio, video) }

  store :data, accessors: [:rows]

end
