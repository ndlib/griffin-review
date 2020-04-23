class VideosController < ApplicationController
  autocomplete :video_title, :name
end