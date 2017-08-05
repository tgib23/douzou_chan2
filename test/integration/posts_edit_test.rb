require 'test_helper'

class PostsEditTest < ActionDispatch::IntegrationTest
  def setup
    @post = posts(:two)
    @user = User.find_by( uid: 102)
  end

#  test "post edit" do
#    get post_path(@post)
#  end
end
