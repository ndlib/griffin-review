class HomepageController < ApplicationController


  def index
    if permission.current_user_is_administrator?
      redirect_to requests_path
    else
      redirect_to courses_path
    end
  end


end
