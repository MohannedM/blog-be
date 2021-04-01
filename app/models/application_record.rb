class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  #config.active_job.queue_adapter = :sidekiq
end
