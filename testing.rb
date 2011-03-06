puts "Using rspec and rspec-rails..."

remove_file "test/"

inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
  (" " * 6) + "generator.test_framework :rspec, :views => false\n"
end

gem 'rspec-rails',      '>= 2.0.0', :group => :test
gem 'database_cleaner',             :group => :test

bundle

generate "rspec:install"

gem 'mocha', :group => :test
gem 'rspec-rails-mocha', '~> 0.3.0', :group => :test

append_file "spec/spec_helper.rb" do
  "Mocha::Configuration.warn_when(:stubbing_non_existent_method)\n" +
  "Mocha::Configuration.warn_when(:stubbing_non_public_method)"
end

gsub_file "spec/spec_helper.rb", /config\.mock_with :rspec/, "config.mock_with :mocha"
bundle

append_file("spec/spec_helper.rb") { "\nDatabaseCleaner.strategy = :truncation" }

append_file(".rspec") { "\n--tty" }

git :add => ".", :rm => "test/*", :commit => "-m 'Use rspec for testing'"

puts "Installing factory_girl..."
gem 'factory_girl_rails', :group => :test

inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
  (" " * 6) + "generator.fixture_replacement :factory_girl, :dir => '#{@use_rspec ? "spec/factories" : "test/factories"}'\n"
end

bundle
commit_all 'Use factory_girl'

puts "Using infinity_test..."
gem "ZenTest", :group => :test
gem "infinity_test", :group => :test
bundle
commit_all 'Use infinity_test'

puts "Using Cucumber for acceptance testing, with Capybara and RSpec"
gem 'database_cleaner', :group => :test
gem 'cucumber-rails',   :group => :test
gem 'launchy',          :group => :test
gem 'capybara',         :group => :test

bundle

generate "cucumber:install", %w{--capybara --rspec}

run "curl -s -L #{@templates_path}/resources/factory_girl_steps.rb > features/step_definitions/factory_girl_steps.rb"

commit_all 'Use cucumber for acceptance testing'
