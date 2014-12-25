Sidekiq.configure_server do |config|
  config.redis = { :url => ENV["REDISCLOUD_URL"], :namespace => "guitar_lessons#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => ENV["REDISCLOUD_URL"], :namespace => "guitar_lessons#{Rails.env}" }
end