Sidekiq.configure_server do |config|
  config.redis = { :url => 'redis://localhost:6379/0', :namespace => "guitar_lessons#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => 'redis://localhost:6379/0', :namespace => "guitar_lessons#{Rails.env}" }
end