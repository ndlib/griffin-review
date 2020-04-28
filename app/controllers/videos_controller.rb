class VideosController < ApplicationController
  autocomplete :video_title, :name, :full => true
end