class MultideleteRequestsController < ApplicationController
  def destroy
    p("HELLO WORLD")
    p(params)
    p("END WORLD")
    redirect_to course_reserves_path('202010_IT')
  end
end
