json.extract! contribution, :id, :user_id, :post_id, :diff, :created_at, :updated_at
json.url contribution_url(contribution, format: :json)