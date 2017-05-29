require 'test_helper'

class PostsEditTest < ActionDispatch::IntegrationTest
  def setup
    @post = posts(:two)
  end

  test "post edit" do
    get post_path(@post)
  end
end
