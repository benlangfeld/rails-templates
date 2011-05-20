@cuke_backend = SETTINGS['cucumber']['backend'] || 'capybara'

gem 'cucumber-rails',   :group => :test
gem 'database_cleaner', :group => :test
gem 'launchy',          :group => :test
gem @cuke_backend,      :group => :test

@strategies << lambda do
  options = ["--#{@cuke_backend}"]
  options << "--rspec" if SETTINGS['enabled_recipes'].include? 'rspec'

  generate "cucumber:install", options

  get "#{TEMPLATES_PATH}/resources/factory_girl_steps.rb", "features/step_definitions/factory_girl_steps.rb" if SETTINGS['enabled_recipes'].include? 'factory_girl'

  commit_all 'Use cucumber for acceptance testing'
end
