class PostsController < ApplicationController

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

  private

    def post_params
      params.require(:post).permit(:name, :coordinate, :country,
                                   :province, :city, :address,
                                   :year, :link, :author, :user_id)
    end

end
