json.extract! correspondence, :id, :subject, :sender, :recipient, :sent_at, :document_id, :created_at, :updated_at
json.url correspondence_url(correspondence, format: :json)
