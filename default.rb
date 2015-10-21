# Default Rails application

gem "font-awesome-sass"
gem "foundation-rails"
gem "git"

gem_group :development do
  gem "rack-livereload"
  gem "rack-mini-profiler"
end

gem_group :test do
  gem "codeclimate-test-reporter", require: nil
  gem "database_cleaner"
  gem "guard-livereload"
  gem "guard-minitest"
  gem "guard-pow"
  gem "minifacture"
  gem "minitest-rails"
  gem "minitest-rails-capybara"
  gem "minitest-reporters"
  gem "rake"
end

gem_group :production, :staging do
  gem "unicorn"
end

application do
  %{ config.generators do |g|
    g.test_framework :minitest, fixutre: false
  end }
end

environment :development do
  <<-CODE

    config.assets.prefix = "/dev-assets"

    # Add Rack::LiveReload to the bottom of the middleware stack with the
    # default options.
    config.middleware.use Rack::LiveReload
  CODE
end

file ".travis.yml", <<-CODE
  sudo: false
  language: ruby
  rvm:
    - 2.2.3
  cache: bundler
  addons:
    postgresql: "9.4"
  before_script:
    - psql -c "create database travis_ci_test;" -U postgres
    - cp config/database.travis.yml config/database.yml
    - cp config/secrets.travis.yml config/secrets.yml
  deploy:
    provider: opsworks
    access_key_id: ["AWS_ACCESS_KEY_ID"]
    secret_access_key:
      secure: ["AWS_SECRET_ACCESS_KEY"]
    app-id: ["AWS_APP_ID"]
    on:
      repo: ["GITHUB_REPO_PATH"]
      branch: master
      rvm: 2.2.3
  notifications:
    slack:
      secure: ["SLACK_TOKEN"]
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

  git :init
  git add: "."
  git commit: %{ -m 'Initial commit' }
end
