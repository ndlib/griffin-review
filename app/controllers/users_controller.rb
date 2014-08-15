class UsersController < ApplicationController


  def index
    check_admin_or_admin_masquerading_permission!
    @users = User.where(admin: true)
  end


  def new
    check_admin_or_admin_masquerading_permission!

    #@user = User.find(params[:id])
    @user = User.new
  end


  def create
    check_admin_or_admin_masquerading_permission!
    @user = User.new(user_params)
    @user.admin = true

    if @user.save
      flash[:success] = "#{@user.username} created successfully!"

      redirect_to action: "edit", id: @user
      return
    end

    render :new
  end

  def destroy
    @user = User.find(params[:id])
    @user.delete()

    redirect_to users_path
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

    private

    def user_params
      params.require(:user).permit(:username)
    end

end
