# # config/initializers/sidekiq_cron.rb
# require "sidekiq/cron/job"

# # Define the job to run at the beginning of each month (at midnight)
# Sidekiq::Cron::Job.create(
#   name: "Leave Accrual Job - Monthly",
#   cron: "0 0 1 * *", # This cron expression means the job will run at midnight on the first day of each month
#   class: "LeaveAccrualJob"
# )
