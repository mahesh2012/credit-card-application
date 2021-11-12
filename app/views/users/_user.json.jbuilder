json.extract! user, :id, :name, :email, :pan_card_no, :aadhar_card_no, :created_at, :updated_at
json.url user_url(user, format: :json)
