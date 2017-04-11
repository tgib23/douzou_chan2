class Pic < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  belongs_to :post 
end
