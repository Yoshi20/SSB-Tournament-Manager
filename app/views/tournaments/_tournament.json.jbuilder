json.extract! tournament, :id, :name, :date, :location, :comment, :registration_fee, :occupied_seats, :total_seats, :active, :created_at, :updated_at, :created_at, :updated_at
json.url tournament_url(tournament, format: :json)
