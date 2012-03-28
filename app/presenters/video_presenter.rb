class VideoPresenter < BasePresenter
  presents :video_item
  delegate :title, :to => :video_item
end
