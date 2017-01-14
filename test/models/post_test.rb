require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # This code is not idiomatically correct.
    @post = @user.posts.create(coordinate: "35.7324356,139.6578569",
                     country: "日本",
					 province: "神奈川県",
					 city: "横浜市緑区",
					 address: "日本 神奈川県横浜市緑区青葉台1-1-1",
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

  test "should be valid" do
    assert @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
	@post = @post_default
  end

  test "coordinate, country, province, city, address should be present" do
    @post.coordinate = nil
    assert_not @post.valid?
    @post = @post_default

    @post.country= nil
    assert_not @post.valid?
    @post = @post_default

    @post.province= nil
    assert_not @post.valid?
    @post = @post_default

    @post.city = nil
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
