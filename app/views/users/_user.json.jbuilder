json.extract! user, :id, :name, :status, :total, :created_at, :updated_at
json.url user_url(user, format: :json)
