class JwtestController < ApplicationController


  def index
    @jwplayer = Jwplayer.new("D05875_Spider-Man.mov", current_user.username, request.remote_ip, params[:token])
  end


end
