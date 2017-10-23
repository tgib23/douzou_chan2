class HomeController < ApplicationController
  def index
    get_and_show_posts
    hot_users
  end

  def siginin
  end

  def admin
    redirect_to root_url unless admin_user?
  end

  def near
    if params[:scale].nil?
      @scale = 1
    else
      @scale = params[:scale].to_i
    end
  end

  def search_nearby

    logger.debug params[:lat]
    logger.debug params[:lon]
    logger.debug params[:scale]
    @latitude  = params[:lat].to_f
    @longitude = params[:lon].to_f
    @scale     = params[:scale].to_i
    @range = 0.002 * @scale
    @nearby_posts = Post.where("latitude>=? AND latitude<?",@latitude-@range,@latitude+@range).where("longitude>=? AND longitude<?",@longitude-@range,@longitude+@range)

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

    # the logic should be updated
    def hot_users
      @hot_users = User.order("RANDOM()").limit(3).where.not(uid: "1")
    end
end
