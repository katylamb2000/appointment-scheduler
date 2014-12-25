# TODO remove. heroku deploy only
if ENV["REDISCLOUD_URL"]
    $redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
end