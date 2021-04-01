  
Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/12') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/12') }
end


require 'sidekiq'
sidekiq_file = "config/sidekiq.yml"
if File.exist?(sidekiq_file) and Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(sidekiq_file)
end