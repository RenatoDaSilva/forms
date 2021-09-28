source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'devise_token_auth'
gem 'friendly_id', '~> 5.1.0'
gem 'omniauth'
gem 'pg', '~> 0.18'
gem 'puma', '~> 4.3'
gem 'rack-attack'
gem 'rack-cors'
gem 'rails', '~> 5.0.1'
gem 'rubocop', require: false

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
