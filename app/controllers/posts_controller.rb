class PostsController < ApplicationController

  def new
    if user_signed_in?
      @post = current_user.posts.build
      @pic = @post.pics.build
      @user = current_user
    end
  end

  def show
    @post = Post.find(params[:id])
    @pics = @post.pics.all
  end

  def create
    if user_signed_in?
      @user = current_user
    end
    @post = current_user.posts.build(post_params)
    puts "now in create #{current_user.uid}"

    respond_to do |format|
      if !params[:pics].nil? && @post.save
        params[:pics]['avatar'].each do |a|
          @pic = @post.pics.create!(:avatar => a)
        end
        flash[:success] = "Post created by #{current_user.uid}"
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
    @lat=params[:lat]
    @lon=params[:lon]
    @coordinate = @lat + "," + @lon
    geo_info = Geocoder.search(@coordinate)[0].address_components
    @country = geo_info.select{|e| e['types'] == ["country", "political"]}[0]["long_name"]
    @administrative_area_level_1 = geo_info.select{|e| e['types'] == ["administrative_area_level_1", "political"]}[0]["long_name"]
    @locality = extract_long_name(
      geo_info.select{|e|
        e['types'].include?("locality") && e['types'].include?("political") && !e['types'].include?("ward")
      }
    )
    @ward = extract_long_name(
      geo_info.select{|e|
        e['types'].include?("locality") && e['types'].include?("political") && e['types'].include?("ward")
      }
    )
   @sublocality_level_1 = extract_long_name(
     geo_info.select{|e|
       e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_1")
     }
   )
   @sublocality_level_2 = extract_long_name(
     geo_info.select{|e|
       e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_2")
     }
   )
   @sublocality_level_3 = extract_long_name(
     geo_info.select{|e|
       e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_3")
     }
   )
   @sublocality_level_4 = extract_long_name(
     geo_info.select{|e|
       e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_4")
     }
   )
   @sublocality_level_5 = extract_long_name(
     geo_info.select{|e|
       e['types'].include?("sublocality") && e['types'].include?("political") && e['types'].include?("sublocality_level_5")
     }
   )

  @address = geo_info.map{|ad| ad['long_name']}[1..-1].reverse.join(' ')

    respond_to do |format|
      format.js
    end
  end

  private

    def post_params
      params.require(:post).permit(:name, :coordinate, :country,
                                   :administrative_area_level_1, :address,
                                   :locality, :ward, :sublocality_level_1, :sublocality_level_2,
                                   :sublocality_level_3, :sublocality_level_4, :sublocality_level_5,
                                   :year, :link, :author, :user_id,
                                   pics: [:id, :post_id, :avatar])
    end

    def extract_long_name (r)
      r[0]["long_name"] unless r.empty?
    end
end
