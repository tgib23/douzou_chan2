require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
#    assert_select 'title', full_title(@user.uid)
#   ココからしたは後ほど
#    assert_select 'h1', text: @user.name
#    assert_select 'h1>img.gravatar'
#    assert_match @user.posts.count.to_s, response.body
#    assert_select 'div.pagination'
#    @user.posts.paginate(page: 1).each do |post|
#      assert_match post.content, response.body
#    end
  end
  # test "the truth" do
  #   assert true
  # end
end
