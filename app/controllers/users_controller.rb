class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
    @post = current_user.posts.build
  end

  def edit
    @user = User.find(params[:id])
  end

end
