# Default Rails application
 
gem "foundation-rails"
 
gem_group :development do
  gem "rack-livereload"
end
 
gem_group :test do
  gem "database_cleaner"
  gem "guard-livereload"
  gem "guard-minitest"
  gem "guard-pow"
  gem "minifacture"
  gem "minitest-rails"
  gem "minitest-rails-capybara"
  gem "rake"
end

environment do
  %Q{ config.generators do |g|
    g.test_framework :minitest, spec: true, fixutre: false
  end }
end

file ".travis.yml", <<-CODE
  language: ruby
  cache: bundler
  addons:
    postgresql: "9.4"
  before_script:
    - psql -c "create database travis_ci_test;" -U postgres
    - cp config/database.travis.yml config/database.yml
    - cp config/secrets.travis.yml config/secrets.yml
CODE

file "config/database.travis.yml", <<-CODE
  test:
    adapter: postgresql
    database: travis_ci_test
    username: postgres
CODE

file "config/secrets.travis.yml", <<-CODE
  test:
    secret_key_base: 8b0411c162885e33869879dd49959f36cbbbe95970a126d3a691c34f29fc36063f6241b226d140d597d9341e69b8eddcec44a428a2e8e87d93fe8cc077a3de28
CODE

after_bundle do
  run "bundle exec spring binstub --all"
  run "rails g foundation:install"
  run "guard init"
end
