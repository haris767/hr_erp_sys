# config/initializers/business_time.rb
BusinessTime::Config.holidays = [
  Date.new(2025, 12, 25), # Christmas
  Date.new(2025, 1, 1),   # New Year's Day
  Date.new(2025, 5, 1),   # Labour's day
  Date.new(2025, 6, 9),   # Eid holiday
  # Add other holidays here
]
