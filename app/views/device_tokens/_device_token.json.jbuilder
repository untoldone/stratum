json.extract! device_token, :id, :token, :device_id, :created_at, :updated_at
json.url device_token_url(device_token, format: :json)
