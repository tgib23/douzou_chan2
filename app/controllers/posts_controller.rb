require 'wikipedia'

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  NEW_POST_PT_NO_NAME      = 50
  UPDATE_POST_PT           = 10
  NEW_POST_PT_NO_WIKI      = 1000
  NEW_POST_PT_WIKI_MAJOR   = 500
  NEW_POST_PT_WIKI_MINOR   = 800
  MAJOR_MINOR_THRESHOLD    = 1000 # temporal

  def index
    redirect_to root_url unless admin_user?
    @posts = Post.all
  end

  def new
    if user_signed_in?
      @post = current_user.posts.build
      @pic = @post.pics.build
      @user = current_user
    else
      @user = User.find_by( uid: 1)
      @post = @user.posts.build
      @pic = @post.pics.build
    end
  end

  def show
    @admin = false
    if user_signed_in?
      @user = current_user
      @admin = true if @user.id == Settings.root.user_id
      @comment = current_user.comments.build
    else
      @user = User.find_by( uid: 1)
    end
    @pics = @post.pics.paginate(page: params[:page], per_page: 5).order('created_at DESC')
    @hash = Gmaps4rails.build_markers(@post) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow post.name
      marker.json({title: post.name})
    end
    @nearby_posts = nearby_posts(@post)
    @nearby_hash= Gmaps4rails.build_markers(@nearby_posts) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow post.name
      marker.json({title: post.name})
      marker.picture({url: 'http://maps.google.com/mapfiles/ms/icons/blue.png', width: 48, height: 48})
    end
    @comments = @post.comments.paginate(page: params[:page])
    post_like_all_key = "#{@post.id}_all"
    post_like_all_value = PostLike.find_by(key: post_like_all_key).value
    if post_like_all_value.empty?
      @like_count = 0
      @like_by_current_user = false
    else
      @like_count = post_like_all_value.split(",").size
      if user_signed_in?
          post_like_user_key = "#{@post.id}_#{current_user.id}"
        if PostLike.find_by(key: post_like_user_key).nil?
          @like_by_current_user = false
        else
          @like_by_current_user = true
        end
      else
        @like_by_current_user = false
      end
    end
  end

  def edit
    if user_signed_in?
      @user = current_user
      @pic = @post.pics.build
    else
      flash[:error] = "You have to login for Update the post"
      redirect_to @post
    end
  end

  def update
    if user_signed_in?
      @user = current_user
    else
      @user = User.find_by( uid: 1)
    end

    diff = Hash.new
    attributions = [:country, :address, :name, :year, :link, :author]
    attributions.each {|attr|
      if (post_params[attr] != @post[attr])
        diff[attr] = [@post[attr], post_params[attr]]
      end
    }

    if params[:pics]
      params[:pics]['avatar'].each do |a|
        @pic = @post.pics.create!(:avatar => a, :user_id => @user.id)
        pic_like = PicLike.new
        pic_like.key = "#{@pic.id}_all"
        pic_like.value = ""
        pic_like.save
      end
    end

    @contribution = Contribution.new
    @contribution.post_id = @post.id
    @contribution.user_id = current_user.id
    @contribution.diff    = diff.to_s
    point_of_this_update  = calc_update_pt(diff)
    @contribution.point   = point_of_this_update
    if @post.update_attributes(post_params)
      @contribution.save
        current_user.sum_point += point_of_this_update
        current_user.save
      flash[:success] = "Post updated"
      redirect_to @post
    else
      render 'edit'
    end
  end


  def create
    if user_signed_in?
      @user = current_user
    else
      @user = User.find_by( uid: 1)
    end
    @post = @user.posts.build(post_params)


    respond_to do |format|
      if !params[:pics].nil? && @post.save
        params[:pics]['avatar'].each do |a|
          @pic = @post.pics.create!(:avatar => a, :user_id => @user.id)
          pic_like = PicLike.new
          pic_like.key = "#{@pic.id}_all"
          pic_like.value = ""
          pic_like.save
        end

        @contribution = Contribution.new
        @contribution.user_id = @user.id
        @contribution.post_id = @post.id
        point_of_this_post = calc_new_pt(@post)
        if point_of_this_post == NEW_POST_PT_WIKI_MINOR || point_of_this_post == NEW_POST_PT_WIKI_MAJOR
          @post.wikipedia_name = @post.name
          @post.save
        end
        @contribution.point   = point_of_this_post
        @contribution.save
        @user.sum_point       += point_of_this_post
        @user.save

        @post_like = PostLike.new
        @post_like.key = "#{@post.id}_all"
        @post_like.value = ""
        @post_like.save

        flash[:success] = "Post created by #{@user.uid}"
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post.id }
      else
        flash[:error] = "Post was not created"
        format.html { redirect_to :action => "new", notice: 'Post was not created' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_geo
    logger.debug params[:lat]
    logger.debug params[:lon]
    @latitude=params[:lat]
    @longitude=params[:lon]
    coordinate = @latitude + "," + @longitude
    Geocoder.configure(:language  => :en)
    geo_info = Geocoder.search(coordinate)[0].address_components
    Geocoder.configure(:language  => :ja)
    geo_info_ja = Geocoder.search(coordinate)[0].address_components
    @country    = geo_info.select{|e| e['types'] == ["country", "political"]}[0]["long_name"]
    @country_ja = geo_info_ja.select{|e| e['types'] == ["country", "political"]}[0]["long_name"]
    @administrative_area_level_1    = geo_info.select{|e| e['types'] == ["administrative_area_level_1", "political"]}[0]["long_name"]
    @administrative_area_level_1_ja = geo_info.select{|e| e['types'] == ["administrative_area_level_1", "political"]}[0]["long_name"]

    @locality = extract_long_name(
      geo_info.select{|e|
        e['types'].include?("locality") && e['types'].include?("political") && !e['types'].include?("ward")
      }
    )
    @locality_ja = extract_long_name(
      geo_info_ja.select{|e|
        e['types'].include?("locality") && e['types'].include?("political") && !e['types'].include?("ward")
      }
    )
    @ward = extract_long_name(
      geo_info.select{|e|
        e['types'].include?("locality") && e['types'].include?("political") && e['types'].include?("ward")
      }
    )
    @ward_ja = extract_long_name(
      geo_info_ja.select{|e|
        e['types'].include?("locality") && e['types'].include?("political") && e['types'].include?("ward")
      }
    )
    @sublocality_level_1 = extract_long_name(
      geo_info.select{|e|
        e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_1")
      }
    )
    @sublocality_level_1_ja = extract_long_name(
      geo_info_ja.select{|e|
        e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_1")
      }
    )
    @sublocality_level_2 = extract_long_name(
      geo_info.select{|e|
        e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_2")
      }
    )
    @sublocality_level_2_ja = extract_long_name(
      geo_info_ja.select{|e|
        e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_2")
      }
    )
    @sublocality_level_3 = extract_long_name(
      geo_info.select{|e|
        e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_3")
      }
    )
    @sublocality_level_3_ja = extract_long_name(
      geo_info_ja.select{|e|
        e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_3")
      }
    )
    @sublocality_level_4 = extract_long_name(
      geo_info.select{|e|
        e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_4")
      }
    )
    @sublocality_level_4_ja = extract_long_name(
      geo_info_ja.select{|e|
        e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_4")
      }
    )
    @sublocality_level_5 = extract_long_name(
      geo_info.select{|e|
        e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_5")
      }
    )
    @sublocality_level_5_ja = extract_long_name(
      geo_info_ja.select{|e|
        e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_5")
      }
    )

    @address    = geo_info.map{|ad| ad['long_name']}[1..-1].reverse.join(' ')
    @address_ja = geo_info_ja.map{|ad| ad['long_name']}[1..-1].reverse.join(' ')

    for_nearby_post = Post.new
    for_nearby_post.latitude = @latitude
    for_nearby_post.longitude = @longitude
    @nearby_pics = Array.new
    @nearby_posts = nearby_posts(for_nearby_post)
    @nearby_posts.each do |np|
      @nearby_pics.push(np.pics.all[0])
    end

    respond_to do |format|
      format.js
    end
  end

  def get_wiki
    @post = Post.find(params[:post_id])
    if @post.wikipedia_name.nil?
      @wiki_summary = ""
    else
      wiki_conf(@post.wikipedia_name)

      @wiki_summary = Wikipedia.find(@post.wikipedia_name).summary
      @wiki_summary = @wiki_summary.gsub(/\n/,"")
    end

    respond_to do |format|
      format.js
    end
  end

  def like_post

    if user_signed_in? && current_user.id == params[:user_id].to_i
      all_key = "#{params[:id]}_all"
      user_key = "#{params[:id]}_#{current_user.id}"
      @all = PostLike.find_by(key: all_key)
      new_value = make_new_value(params[:user_id], @all.value)
      @all.value = new_value
      @all.save
      @like_count = @all.value.split(",").size

      #user_key
      @post_user_like = PostLike.new
      @post_user_like.key = user_key
      @post_user_like.value = "1"
      @post_user_like.save
    end
  end

  def like_pic

    if user_signed_in? && current_user.id == params[:user_id].to_i
	  @pic_id = params[:id]
      all_key = "#{params[:id]}_all"
      user_key = "#{params[:id]}_#{current_user.id}"
      @all = PicLike.find_by(key: all_key)
      new_value = make_new_value(params[:user_id], @all.value)
      @all.value = new_value
      @all.save
      @pic_like_count = @all.value.split(",").size

      #user_key
      @pic_user_like = PicLike.new
      @pic_user_like.key = user_key
      @pic_user_like.value = "1"
      @pic_user_like.save
    end
  end


  private

    def post_params
      params.require(:post).permit(:name, :latitude, :longitude, :country,
                                   :administrative_area_level_1, :address,
                                   :locality, :ward, :sublocality_level_1, :sublocality_level_2,
                                   :sublocality_level_3, :sublocality_level_4, :sublocality_level_5,
                                   :country_ja, :administrative_area_level_1_ja, :address_ja,
                                   :locality_ja, :ward_ja, :sublocality_level_1_ja, :sublocality_level_2_ja,
                                   :sublocality_level_3_ja, :sublocality_level_4_ja, :sublocality_level_5_ja,
                                   :year, :link, :author, :user_id, :wikipedia_name,
                                   pics: [:id, :post_id, :avatar])
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def extract_long_name (r)
      r[0]["long_name"] unless r.empty?
    end

    def nearby_posts(target)
      Post.where("latitude>=? AND latitude<?",target.latitude-0.002,target.latitude+0.002).where("longitude>=? AND longitude<?",target.longitude-0.002,target.longitude+0.002)
    end

    # calc point of new post algorithm
    def calc_new_pt(post)
      if post.name.empty?
        NEW_POST_PT_NO_NAME
      else
        wiki_conf(post.name)

        # algorithm should be implemented later
        wiki_results = Wikipedia.find("#{post.name}").summary
        if wiki_results.nil?
          NEW_POST_PT_NO_WIKI
        else
          if wiki_results.size > MAJOR_MINOR_THRESHOLD
            NEW_POST_PT_WIKI_MAJOR
          else
            NEW_POST_PT_WIKI_MINOR
          end
        end
      end
    end

    # calc point of post update algorithm
    def calc_update_pt(diff)
      # algorithm should be implemented later
      diff.size * UPDATE_POST_PT
    end

    def alphabet?(s)
      (s =~ /^[A-Za-z\s\!-\/\:-\?\[-\_\{-\}]+$/) == 0
    end

    def wiki_conf(name)
      if !alphabet?(name)
         Wikipedia.configure {
           domain 'ja.wikipedia.org'
           path   'w/api.php'
         }
      else
         Wikipedia.configure {
           domain 'en.wikipedia.org'
           path   'w/api.php'
         }
      end
    end

    def make_new_value(id, value)
      arr = value.split(",").map(&:to_i)
      arr.push(id.to_i).sort.join(',')
    end

end
