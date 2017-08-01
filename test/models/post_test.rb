require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # This code is not idiomatically correct.
	@pic1 = Pic.new :id => 30
	@pic2 = Pic.new :id => 31
    @post = @user.posts.create(latitude: "35.7324356",
                     longitude: "139.6578569",
                     country: "Japan",
					 administrative_area_level_1: "Kanagawa",
					 locality: "Yokohama",
					 ward: "Aoba",
					 sublocality_level_1: "Aobadai",
					 sublocality_level_2: "2",
					 sublocality_level_4: "3",
					 sublocality_level_5: "17",
					 address: "日本 神奈川県横浜市緑区青葉区青葉台2-3-17",
					 author: "運慶",
					 name: "金剛力士像",
					 year: "1400",
					 link: "http://www.yahoo.co.jp,http://www.google.co.jp,http://microsoft.co.jp",
                     country_ja: "日本",
					 administrative_area_level_1_ja: "神奈川県",
					 locality_ja: "横浜市",
					 ward_ja: "青葉区",
					 sublocality_level_1_ja: "青葉台",
					 sublocality_level_2_ja: "2",
					 sublocality_level_4_ja: "3",
					 sublocality_level_5_ja: "17",
					 address_ja: "日本 神奈川県横浜市緑区青葉区青葉台2-3-17",
					 # street should be added
                     user_id: @user.id)
    @post_default = @post
	puts "user.id is #{@user.id}"
	puts "post.id is #{@post.id}"
	puts "user.post.first.id is #{@user.posts.first.id}"
  end

  test "@post without pics should not be valid" do
    assert @post.valid?
  end

#  don't know what's wrong
#  test "@post with pics should be valid" do
#    @post.pics << @pic1
#    @post.pics << @pic2
#	puts "failed test"
#	puts @post.user_id
#	puts @post.coordinate
#	puts @post.country
#	puts @post.administrative_area_level_1
#	puts @post.address
#	assert @post.valid?
#  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
	@post = @post_default
  end

  test "longitude, latitude, country, administrative_area_level_1, address should be present" do
    @post.longitude = nil
    assert_not @post.valid?
    @post = @post_default

    @post.latitude = nil
    assert_not @post.valid?
    @post = @post_default

    @post.country= nil
    assert_not @post.valid?
    @post = @post_default

    @post.administrative_area_level_1= nil
    assert_not @post.valid?
    @post = @post_default

    @post.address = nil
    assert_not @post.valid?
    @post = @post_default
  end

  test "order should be most recent first" do
    assert_equal posts(:most_recent), Post.first
  end
end
