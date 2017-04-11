json.extract! pic, :id, :pic_id, :avatar, :created_at, :updated_at
json.url pic_url(pic, format: :json)