class UsersController < ApplicationController
  before_action :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
#    debugger
    @posts = @user.posts.paginate(page: params[:page])
    @post = current_user.posts.build
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:email, :password,
                                   :password_confirmation)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
