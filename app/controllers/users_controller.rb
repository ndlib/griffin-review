class UsersController < ApplicationController


  def index
    @users = User.where(admin: true)
  end


  def new
    @user = User.find(params[:id])
  end


  def create

  end

  def edit
    @user = User.find(params[:id])
    @filter = RequestFilter.new(self, @user)
  end


  def update
    @user = User.find(params[:id])
    filter = RequestFilter.new(self, @user)

    filter.save_filter_for_user!

    redirect_to users_path
  end


end
