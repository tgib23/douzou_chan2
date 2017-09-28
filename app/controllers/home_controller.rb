class HomeController < ApplicationController
  def index
    get_and_show_posts
  end

  def siginin
  end

  def admin
    redirect_to root_url unless user_signed_in? && current_user.id == Settings.root.user_id
  end

  private
    def get_and_show_posts
      @show_post = Post.paginate(page: params[:page], per_page: 5).order('created_at DESC')
      respond_to do |format|
          format.html
          format.js
      end
    end
end
