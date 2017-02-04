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
                                   :year, :link, :author, :user_id)
    end

    def extract_long_name (r)
      r[0]["long_name"] unless r.empty?
    end
end
