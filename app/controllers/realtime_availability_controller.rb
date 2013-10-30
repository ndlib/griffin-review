class RealtimeAvailabilityController < ApplicationController

  layout 'empty'

  def show
    params[:key] = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
    @rta = Rta.new(params[:id], params[:key])
    raise "hi"
  end
end
