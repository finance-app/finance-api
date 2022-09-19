source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'

gem 'active_model_serializers', '~> 0.10.12'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.16'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'


# Use Knock as authentication gem
#
# Need to use this specific commit, which is unofficially the 2.2 release,
#   because the new version hasn't been released to RubyGems yet.
gem "knock", github: "nsarno/knock", branch: "master",
    ref: "9214cd027422df8dc31eb67c60032fbbf8fc100b"

# Workaround for https://github.com/seattlerb/minitest/issues/730
gem 'minitest', '5.10.3'

# Use table_print gem to print nice tables from rails console
gem 'table_print'

# Use PaperTrail gem to track changes in models data
gem 'paper_trail'

# Use SimpleEnum gem to support enum fields in models
gem 'simple_enum'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'lol_dba'
  gem 'bullet'
  gem 'query_trail', :git => 'https://github.com/route/query_trail'
  gem 'irb'
  gem 'mini_portile2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# To optimize JSON generation
gem 'multi_json'
gem 'oj'
gem 'oj_mimic_json'


# To do bulk imports
gem 'activerecord-import'

gem "rdoc", "~> 6.4"

gem "strscan", "3.0.1"
gem "stringio", "3.0.1"
