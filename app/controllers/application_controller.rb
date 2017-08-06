class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if @user.first_login == 1
      @user.first_login = 0
      @user.save
      edit_user_path(@user)
    else
      @user
    end
  end
end
