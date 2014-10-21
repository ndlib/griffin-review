class MediaPlaylist < ActiveRecord::Base

  store :data, accessors: [:rows]

end
