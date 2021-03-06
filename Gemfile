source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# NOTE: Why Postgres instead of Mongo? Because I wanted to use PostGIS for
# its spatial functions. See README.md for more details
gem 'pg'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'time_difference'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # NOTE: Why not factory girl? I don't have a strong opinion, but in the past
  #       (over 5 years ago) I've run into a few hiccups with Factory Girl that
  #       I never ran into with Fabrication. Now it's just a habit to use this
  #       gem.
  gem 'fabrication'
  gem 'nyan-cat-formatter'
  # NOTE: Why rspec? Habit. I would be okay with other testing frameworks
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'timecop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
