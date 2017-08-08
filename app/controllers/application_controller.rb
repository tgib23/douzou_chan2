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
end
