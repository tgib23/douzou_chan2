class UsersController < ApplicationController
  before_action :admin_user,     only: :destroy

  def index
    redirect_to root_url unless admin_user?
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])

    # temporal debug
    if user_signed_in?
      @post = current_user.posts.build
    end

    @hash = Gmaps4rails.build_markers(@posts) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow post.name
      marker.json({title: post.name})
    end
  end

  def edit
    @user = User.find(params[:id])
    if user_signed_in?
      redirect_to @user unless @user.id == current_user.id or current_user.id == Settings.root.user_id
      @control_ban = current_user.id == Settings.root.user_id
    else
      redirect_to @user
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :nickname, :password,
                                   :password_confirmation, :banned, :image)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
