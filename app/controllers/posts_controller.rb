class PostsController < ApplicationController

  def new
    if user_signed_in?
      @post = current_user.posts.build
      @user = current_user
    end
  end

  def create
    @post = current_user.posts.build(post_params)
puts "now in create #{current_user.uid}"
    if @post.save
      flash[:success] = "Post created by #{current_user.uid}"
      redirect_to root_url
    else
      render 'welcome/home'
    end
  end

  def destroy
  end

  def get_geo
    logger.debug params[:lat]
    logger.debug params[:lon]
    @lat=params[:lat]
    @lon=params[:lon]
    respond_to do |format|
      format.js
    end
  end

  private

    def post_params
      params.require(:post).permit(:name, :coordinate, :country,
                                   :province, :city, :address,
                                   :year, :link, :author, :user_id)
    end

end
