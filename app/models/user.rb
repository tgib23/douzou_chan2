class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :twitter, :google_oauth2]
  has_many :posts
  has_many :comments
  before_save { self.email = email.downcase }
  validates :email, uniqueness: { case_sensitive: false }
  validates :nickname, presence: true
  mount_uploader :image, AvatarUploader

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      nickname = auth.extra.raw_info.name if auth.provider == 'facebook'
      nickname = auth.info.nickname if auth.provider == 'twitter'
      nickname = auth.info.name if auth.provider == 'google_oauth2'

      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        nickname: nickname,
        email:    User.dummy_email(auth),
        password: Devise.friendly_token[0, 20]
      )
    end

    user
  end

  def self.new_with_session(params, session)
   super.tap do |user|
     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
       user.email = data["email"] if user.email.blank?
     end
   end
  end

  private

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
