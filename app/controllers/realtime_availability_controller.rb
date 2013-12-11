class RealtimeAvailabilityController < ApplicationController

  layout 'empty'

  def show
    # this key has been used to match this request up with ones in the api log.  So we can track some of the errors we have been happening.
    params[:key] = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
    @rta = Rta.new(params[:id], params[:key])
  end
end
