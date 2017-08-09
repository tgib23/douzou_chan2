class PostsController < ApplicationController

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
    if user_signed_in?
      @user = current_user
    else
      @user = User.find_by( uid: 1)
    end
    @post = Post.find(params[:id])
    @pics = @post.pics.all
    @hash = Gmaps4rails.build_markers(@post) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow post.name
      marker.json({title: post.name})
    end
    @nearby_posts = nearby_posts(@post)
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

    diff = Hash.new
    attributions = [:country, :address, :name, :year, :link, :author]
    attributions.each {|attr|
      if (post_params[attr] != @post[attr])
        diff[attr] = [@post[attr], post_params[attr]]
      end
    }

    if params[:pics]
      params[:pics]['avatar'].each do |a|
        @pic = @post.pics.create!(:avatar => a)
      end
    end

    @contribution = Contribution.new
    @contribution.post_id = @post.id
    @contribution.user_id = current_user.id
    @contribution.diff = diff.to_s
    if @post.update_attributes(post_params)
      @contribution.save
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
          @pic = @post.pics.create!(:avatar => a)
        end

        @contribution = Contribution.new
        @contribution.user_id = @user.id
        @contribution.post_id = @post.id
        @contribution.save

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
	puts @country_ja
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
end
