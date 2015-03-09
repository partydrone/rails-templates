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
 
after_bundle do
  run "rails g foundation:install"
  run "guard init"
end
