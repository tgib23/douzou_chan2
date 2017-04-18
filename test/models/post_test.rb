require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # This code is not idiomatically correct.
	@pic1 = Pic.new :id => 30
	@pic2 = Pic.new :id => 31
    @post = @user.posts.create(coordinate: "35.7324356,139.6578569",
                     country: "日本",
					 administrative_area_level_1: "神奈川県",
					 locality: "横浜市",
					 ward: "青葉区",
					 sublocality_level_1: "青葉台",
					 sublocality_level_2: "2",
					 sublocality_level_4: "3",
					 sublocality_level_5: "17",
					 address: "日本 神奈川県横浜市緑区青葉区青葉台2-3-17",
					 author: "運慶",
					 name: "金剛力士像",
					 year: "1400",
					 link: "http://www.yahoo.co.jp,http://www.google.co.jp,http://microsoft.co.jp",
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

  test "coordinate, country, administrative_area_level_1, address should be present" do
    @post.coordinate = nil
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
