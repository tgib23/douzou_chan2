class HomeController < ApplicationController
  def index
    get_and_show_posts
  end

  def siginin
  end

  def admin
    redirect_to root_url unless admin_user?
  end

  def near
  end

  def search_nearby

    logger.debug params[:lat]
    logger.debug params[:lon]
    @latitude=params[:lat].to_f
    @longitude=params[:lon].to_f
    @nearby_posts = Post.where("latitude>=? AND latitude<?",@latitude-0.002,@latitude+0.002).where("longitude>=? AND longitude<?",@longitude-0.002,@longitude+0.002)

    @nearby_hash= Gmaps4rails.build_markers(@nearby_posts) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow post.name
      marker.json({title: post.name})
      marker.picture({url: 'http://maps.google.com/mapfiles/ms/icons/blue.png', width: 48, height: 48})
    end
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
