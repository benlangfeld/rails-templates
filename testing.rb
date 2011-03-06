if SETTINGS['rspec']['enabled']
  remove_file "test/"

  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.test_framework :rspec, :views => false\n"
  end

  gem 'rspec-rails',      '>= 2.0.0', :group => :test
  gem 'database_cleaner',             :group => :test

  bundle

  generate "rspec:install"

  if SETTINGS['rspec']['mocha']
    gem 'mocha', :group => :test
    gem 'rspec-rails-mocha', '~> 0.3.0', :group => :test

    append_file "spec/spec_helper.rb" do
      "Mocha::Configuration.warn_when(:stubbing_non_existent_method)\n" +
      "Mocha::Configuration.warn_when(:stubbing_non_public_method)"
    end

    gsub_file "spec/spec_helper.rb", /config\.mock_with :rspec/, "config.mock_with :mocha"
    bundle
  end

  append_file("spec/spec_helper.rb") { "\nDatabaseCleaner.strategy = :truncation" }

  append_file(".rspec") { "\n--tty" }

  git :add => ".", :rm => "test/*", :commit => "-m 'Use rspec for testing'"
end

if SETTINGS['factory_girl']
  gem 'factory_girl_rails', :group => :test

  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.fixture_replacement :factory_girl, :dir => '#{SETTINGS['rspec'] ? "spec/factories" : "test/factories"}'\n"
  end

  bundle
  commit_all 'Use factory_girl'
end

if SETTINGS['infinity_test']
  gem "ZenTest", :group => :test
  gem "infinity_test", :group => :test
  bundle
  commit_all 'Use infinity_test'
end

if SETTINGS['cucumber']['enabled']
  backend = SETTINGS['cucumber']['backend'] || 'capybara'

  gem 'database_cleaner', :group => :test
  gem 'cucumber-rails',   :group => :test, :git => "git://github.com/aslakhellesoy/cucumber-rails.git"
  gem 'launchy',          :group => :test
  gem backend,            :group => :test

  bundle

  options = ["--#{backend}"]
  options << "--rspec" if SETTINGS['rspec']['enabled']

  generate "cucumber:install", options

  run "curl -s -L #{TEMPLATES_PATH}/resources/factory_girl_steps.rb > features/step_definitions/factory_girl_steps.rb" if SETTINGS['factory_girl']

  commit_all 'Use cucumber for acceptance testing'
end
