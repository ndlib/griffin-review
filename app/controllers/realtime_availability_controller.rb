class RealtimeAvailabilityController < ApplicationController

  layout 'empty'

  def show
    @rta = Rta.new(params[:id])
  end
end
