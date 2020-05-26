source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.7'

gem 'rails', '~> 5.2.4', '>= 5.2.4.2'
gem 'sqlite3'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
# gem 'redis', '~> 4.0'
# gem 'bcrypt', '~> 3.1.7'
# gem 'mini_magick', '~> 4.8'
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem "factory_bot_rails"
  gem 'faker'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano3-puma'
  gem 'capistrano-rbenv'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'bullet'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'rubocop-airbnb'
end

group :production do
  gem 'mysql2'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "refile", require: "refile/rails", github: 'manfe/refile'
gem "refile-mini_magick"
gem 'devise'
gem 'pry-rails'
gem 'bootstrap-sass'
gem 'jquery-rails'
gem 'rails-i18n'
gem "simple_calendar", "~> 2.0"
gem 'dotenv-rails'
gem 'font-awesome-sass'
gem 'kaminari', '~> 1.1.1'
gem 'ransack'
gem 'chartkick'
gem 'groupdate'
gem "paranoia", "~> 2.2"
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
# require: falseをつけるのは、このGem自体がRailsアプリの反映するものではなく、
# OS（ターミナル)に反映させるものということ
gem 'whenever', require: false
gem "refile-s3"

