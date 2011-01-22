if y?("Use rspec and rspec-rails?")
  @use_rspec = true

  remove_file "test/"

  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.test_framework :rspec, :views => false\n"
  end

  gem 'rspec',            '>= 2.0.0', :group => :test
  gem 'rspec-rails',      '>= 2.0.0', :group => :test
  gem 'database_cleaner',             :group => :test

  run "bundle install"

  generate "rspec:install"

  if y?("Install mocha?")
    gem 'mocha', :group => :test

    append_file "spec/spec_helper.rb" do
      "Mocha::Configuration.warn_when(:stubbing_non_existent_method)\n" +
      "Mocha::Configuration.warn_when(:stubbing_non_public_method)"
    end

    gsub_file "spec/spec_helper.rb", /config\.mock_with :rspec/, "config.mock_with :mocha"
    run "bundle install"
  end

  append_file "spec/spec_helper.rb" do
    "\nDatabaseCleaner.strategy = :truncation"
  end

  append_file ".rspec" do
    "\n--tty"
  end

  git :add => ".", :commit => "-m 'Use rspec for testing'"
end

if y?("Install factory_girl?")
  gem 'factory_girl_rails', :group => :test

  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.fixture_replacement :factory_girl, :dir => '#{@use_rspec ? "spec/factories" : "test/factories"}'\n"
  end

  run "bundle install"

  git :add => ".", :commit => "-m 'Use factory_girl'"
end

if y?("Use infinity_test?")
  gem "ZenTest", :group => :test
  gem "infinity_test", :group => :test
  run "bundle install"
  git :add => ".", :commit => "-m 'Use infinity_test'"
end

if y?("Use Cucumber for acceptance testing?")
  gem 'database_cleaner', :group => :test
  gem 'cucumber',         :group => :test
  gem 'cucumber-rails',   :group => :test
  gem 'launchy',          :group => :test

  if y?("Use Capybara instead of Webrat?")
    gem 'capybara', :group => :test
    @use_capybara = true
  else
    gem 'webrat', :group => :test
  end

  run "bundle install"

  arguments = [].tap do |arguments|
    arguments << "--webrat"    if @use_capybara.nil?
    arguments << "--capybara"  if @use_capybara.present?
    arguments << "--rspec"     if y?("Use with rspec?")
  end

  generate "cucumber:install #{arguments.join(" ")}"

  git :add => ".", :commit => "-m 'Use cucumber for acceptance testing'"
end
