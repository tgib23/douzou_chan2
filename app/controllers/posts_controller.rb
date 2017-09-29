require 'wikipedia'

class PostsController < ApplicationController
  NEW_POST_PT_NO_NAME = 50
  NEW_POST_PT_WIKI    = 100
  UPDATE_POST_PT      = 10
  MAJOR_MINOR_THRESHOLD    = 10000 # temporal
  NEW_POST_PT_GOOGLE_MAJOR = 500
  NEW_POST_PT_GOOGLE_MINOR = 1000

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
    @post = Post.find(params[:id])
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
  end

  def edit
    if user_signed_in?
      @user = current_user
      @post = Post.find(params[:id])
      @pic = @post.pics.build
    else
      @post = Post.find(params[:id])
      flash[:error] = "You have to login for Update the post"
      redirect_to @post
    end
  end

  def update
    @post = Post.find(params[:id])
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
    puts "now in create #{@user.uid}"


    respond_to do |format|
      if !params[:pics].nil? && @post.save
        params[:pics]['avatar'].each do |a|
          @pic = @post.pics.create!(:avatar => a, :user_id => @user.id)
        end

        @contribution = Contribution.new
        @contribution.user_id = @user.id
        @contribution.post_id = @post.id
        point_of_this_post    = calc_new_pt(@post)
        @contribution.point   = point_of_this_post
        @contribution.save
        @user.sum_point       += point_of_this_post
        @user.save

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

  private

    def post_params
      params.require(:post).permit(:name, :latitude, :longitude, :country,
                                   :administrative_area_level_1, :address,
                                   :locality, :ward, :sublocality_level_1, :sublocality_level_2,
                                   :sublocality_level_3, :sublocality_level_4, :sublocality_level_5,
                                   :country_ja, :administrative_area_level_1_ja, :address_ja,
                                   :locality_ja, :ward_ja, :sublocality_level_1_ja, :sublocality_level_2_ja,
                                   :sublocality_level_3_ja, :sublocality_level_4_ja, :sublocality_level_5_ja,
                                   :year, :link, :author, :user_id,
                                   pics: [:id, :post_id, :avatar])
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
        # algorithm should be implemented later
        if !alphabet?(post.name)
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

        if Wikipedia.find("#{post.name}").summary.nil?
          results = GoogleCustomSearchApi.search("#{post.name}")
          if !results.nil? && results.queries.request[0].totalResults.to_i > MAJOR_MINOR_THRESHOLD
			puts "koko1", results.queries.request[0]
            NEW_POST_PT_GOOGLE_MAJOR
          else
			puts "koko2", results.queries.request[0]
            NEW_POST_PT_GOOGLE_MINOR
          end
        else
		  puts "koko3"
          NEW_POST_PT_WIKI
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

end
