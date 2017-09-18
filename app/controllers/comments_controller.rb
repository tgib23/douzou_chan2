class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :admin_user,   only: :destroy
  ADMIN_USER_ID = 2

  def create
    @comment = current_user.comments.build(comment_params)
puts "comment.post id is #{@comment.post_id}"
    if @comment.save
      flash[:success] = "comment created!"
      redirect_to controller: 'posts', action: 'show', id: @comment.post_id
    else
      render current_user
    end
  end

  def destroy
    post_id = @comment.post_id
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to controller: 'posts', action: 'show', id: @comment.post_id
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :post_id, :user_id)
    end

    def admin_user
      redirect_to root_url unless current_user.id == ADMIN_USER_ID
      @comment = current_user.comments.find_by(id: params[:id])
    end
end
