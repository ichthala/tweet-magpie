require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['YOUR_CONSUMER_KEY'],
  config.consumer_secret     = ENV['YOUR_CONSUMER_SECRET'],
  config.access_token        = ENV['YOUR_OAUTH_TOKEN']
  config.access_token_secret = ENV['YOUR_OAUTH_TOKEN_SECRET']
end

Magpie.new.go(client, 'ichthala')
