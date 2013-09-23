class UsersController < ApplicationController


  def index
    @users = User.where(admin: true)
  end


  def show

  end


  def new

  end


  def create

  end


  def update

  end


end
