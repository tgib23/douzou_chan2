class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def after_sign_in_path_for(resource)
    if @user.first_login == 1
      @user.first_login = 0
      @user.save
      edit_user_path(@user)
    else
      @user
    end
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless user_signed_in?
      flash[:danger] = "Please log in."
      redirect_to root_url
    end
  end
end
