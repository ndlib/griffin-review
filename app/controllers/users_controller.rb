class UsersController < ApplicationController


  def index
    check_admin_or_admin_masquerading_permission!
    @users = User.where(admin: true)
  end


  def new
    check_admin_or_admin_masquerading_permission!

    @user = User.find(params[:id])
  end


  def create
    check_admin_or_admin_masquerading_permission!
  end


  def edit
    check_admin_or_admin_masquerading_permission!

    @user = User.find(params[:id])
    @filter = RequestFilter.new(self, @user)
  end


  def update
    check_admin_or_admin_masquerading_permission!

    @user = User.find(params[:id])
    filter = RequestFilter.new(self, @user)

    filter.save_filter_for_user!

    redirect_to users_path
  end


end
